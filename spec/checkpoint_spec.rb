require './spec/spec_helper'

describe Checkpoint do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  describe "New checkpoint -" do
    let(:user) { User.new_user(email: "email2",
                               password: "password2")}
    let(:start_checkpoint_data) {{ timestamp: 1,
                             lat:       random_location[0],
                             long:      random_location[1],
                             type:      "start" }}
    let(:stop_checkpoint_data) {{ timestamp: 100,
                              lat:       random_location[0],
                              long:      random_location[1],
                              type:      "stop" }}
    let(:heartbeat_checkpoint_data) {{ timestamp: 3,
                                lat:       random_location[0],
                                long:      random_location[1],
                                type:      "heartbeat" }}
    let(:prayer_checkpoint_data) {{ timestamp: 5,
                                  lat:       random_location[0],
                                  long:      random_location[1],
                                  type:      "prayer" }}

    before do
      clean_table(User)
      clean_table(Checkpoint)
      clean_table(Route)
    end

    context "Start -" do

      it "creates a new route" do
        route_count = Route.scan.count
        Checkpoint.add_checkpoint(user.id, start_checkpoint_data)  
        expect(route_count + 1).to eq(Route.scan.count)
      end
    end

    context "Checkpoint Types -" do
      %w(heartbeat, stop, prayer).each_with_index do |type, i|
        context "#{type} -" do
          it "associates checkpoint with the user's most recent route" do 
            start_checkpoint = Checkpoint.add_checkpoint(user.id, start_checkpoint_data)  
            start_checkpoint_data[:type] = type
            start_checkpoint_data[:timestamp] = i * 2
            checkpoint = Checkpoint.add_checkpoint(user.id, start_checkpoint_data)
            expect(checkpoint.route_id).to eq(start_checkpoint.route_id)
          end
        end
      end
    end

    context "Stop -" do
      it "calculates and fills in the route data" do 
        start_checkpoint = Checkpoint.add_checkpoint(user.id, start_checkpoint_data)
        for i in 1..3 do
          heartbeat_checkpoint_data[:timestamp] += i
          Checkpoint.add_checkpoint(user.id, heartbeat_checkpoint_data)
        end

        stop_checkpoint = Checkpoint.add_checkpoint(user.id, stop_checkpoint_data)
        test_route = Route.find(id: start_checkpoint.route_id)
        expect(test_route.seconds).to eq(stop_checkpoint.timestamp - start_checkpoint.timestamp)
      end
    end
  end

  describe "last_prayer_name -" do 
    let(:user) { User.new_user(email: "email", password: "password")}
    let(:prayer) {{ timestamp: Time.now.to_i,
                   lat:       random_location[0],
                   long:      random_location[1],
                   type:      "prayer" }}

    before do
      clean_table(Checkpoint)
    end

    context "when there are no names -" do
      xit "returns nothing" do
        expect(Checkpoint.last_name(user.id)).to be_falsey
      end
    end

    context "when there are names -" do
      # user.add_checkpoint(prayer)
      xit "returns the last name prayed for" do
        expect(Checkpoint.last_name(user.id)).to eq "Steve"
      end
    end
  end
end