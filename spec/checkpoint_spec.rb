require './spec/spec_helper'

describe Checkpoint do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  let(:user) { User.new_user(email: "email2",
    password: "password2")}
  let(:start_checkpoint_data) {{ "recorded_at" => 1,
                                  "lat"     =>  random_location[0],
                                  "long"    =>  random_location[1],
                                  "type"    =>  "start",
                                  "user_id" =>  user.email }}
  let(:stop_checkpoint_data) {{ "recorded_at" => 100,
    "lat"     =>  random_location[0],
    "long"    =>  random_location[1],
    "type"    =>  "stop",
    "user_id" =>  user.email }}
  let(:heartbeat_checkpoint_data) {{ "recorded_at" => 3,
      "lat"     =>  random_location[0],
      "long"    =>  random_location[1],
      "type"    =>  "heartbeat",
      "user_id" =>  user.email }}
  let(:prayer_checkpoint_data) {{ "recorded_at" => 5,
        "lat"     =>  random_location[0],
        "long"    =>  random_location[1],
        "type"    =>  "prayer",
        "user_id" =>  user.email,
        "match_key" => "match_key" }}

  before do
    clean_table(User)
    clean_table(Checkpoint)
    clean_table(Route)
    clean_table(UserResident)
  end

  describe "New checkpoint -" do
    context "Prayer checkpoint when there is a route" do
      it "assigns the current route id to checkpoint" do
        start_checkpoint = Checkpoint.new_checkpoint(start_checkpoint_data)
        sleep 1
        prayer_checkpoint = Checkpoint.new_checkpoint(prayer_checkpoint_data)
        expect(prayer_checkpoint.route_id).to eq(start_checkpoint.route_id)
      end
    end

    context "Prayer checkpoint when there is not a route" do
      it "assigns nil to the checkpoint route" do
        prayer_checkpoint = Checkpoint.new_checkpoint(prayer_checkpoint_data)
        expect(prayer_checkpoint.route_id).to be_nil
      end
    end

    context "On login when there is no previous start" do
      it "does not blow up" do
        expect{Checkpoint.close_last_route(user.email)}.not_to raise_error
      end

      context "when there is a prayer checkpoint" do
        it "does not blow up" do
          prayer_checkpoint = Checkpoint.new_checkpoint(prayer_checkpoint_data)
          expect{Checkpoint.close_last_route(user.email)}.not_to raise_error
        end
      end
    end

    context "Start -" do

      it "creates a new route" do
        route_count = Route.scan.count
        Checkpoint.new_checkpoint(start_checkpoint_data)  
        expect(route_count + 1).to eq(Route.scan.count)
      end
    end

    context "Checkpoint Types -" do
      %w(heartbeat, stop, prayer).each_with_index do |type, i|
        context "#{type} -" do
          it "associates checkpoint with the user's most recent route" do 
            start_checkpoint = Checkpoint.new_checkpoint(start_checkpoint_data)
            start_checkpoint_data[:type] = type
            sleep 1
            checkpoint = Checkpoint.new_checkpoint(start_checkpoint_data)
            expect(checkpoint.route_id).to eq(start_checkpoint.route_id)
          end
        end
      end
    end

    context "Stop -" do
      it "calculates and fills in the route data" do 
        start_checkpoint = Checkpoint.new_checkpoint(start_checkpoint_data)
        for i in 1..3 do
          sleep i
          Checkpoint.new_checkpoint(heartbeat_checkpoint_data)
        end
        sleep 1
        stop_checkpoint = Checkpoint.new_checkpoint(stop_checkpoint_data)
        test_route = Route.find(id: start_checkpoint.route_id)
        expect(test_route.seconds).to eq(stop_checkpoint.recorded_at - start_checkpoint.recorded_at)
      end
    end
  end

  describe "last_user_checkpoint -" do
    context "When there are no checkpoints" do
      it "does not blow up" do
        expect{Checkpoint.last_user_checkpoint(user.email, "prayer")}.not_to raise_error
      end
      it "returns the correct checkpoint" do
        checkpoint = Checkpoint.new(prayer_checkpoint_data)
        Checkpoint.new_checkpoint(start_checkpoint_data)
        expect(checkpoint.user_id).to eq user.email
      end
    end
  end

  describe "last_route_checkpoint -" do
    context "When there are no checkpoints" do
      it "does not blow up" do
        expect{Checkpoint.last_route_checkpoint(user.email, nil)}.not_to raise_error
      end
      it "returns the correct checkpoint" do
        prev_checkpoint = Checkpoint.new_checkpoint(start_checkpoint_data)
        last_route_checkpoint = Checkpoint.last_route_checkpoint(user.email, prev_checkpoint.route_id)
        expect(last_route_checkpoint.recorded_at).to eq prev_checkpoint.recorded_at
      end
    end
  end

  describe "is_valid? -" do
    context "When trailing heartbeat" do
      it "returns falsey" do
        Checkpoint.new_checkpoint(start_checkpoint_data)
        sleep 1
        Checkpoint.new_checkpoint(stop_checkpoint_data)
        sleep 1
        Checkpoint.new_checkpoint(heartbeat_checkpoint_data)
        expect(Checkpoint.last_checkpoint(user.email).type).to_not eq "heartbeat"
      end
    end
    context "When no match_key for prayer checkpoint" do
      it "" do

      end
    end
  end

  describe "last_prayer_name -" do 
    let(:user) { User.new_user(email: "email", password: "password")}
    let(:resident1) {UserResident.new( name: "resident1", address: "address 1", user_id: user.email, match_key: "klfsdlfs;" )}
    let(:prayer) {{ recorded_at: Time.now.to_i,
                   lat:       random_location[0],
                   long:      random_location[1],
                   type:      "prayer",
                   user_id:   user.email,
                   match_key: resident1.match_key }}

    before do
      clean_table(Checkpoint)
      clean_table(User)
    end

    context "when there are no prayers -" do
      it "returns nothing" do
        expect(Checkpoint.last_prayer(user.email)).to be_falsey
      end
    end

    context "when there are prayers -" do
      it "returns the last match_key prayed for" do
        Checkpoint.new_checkpoint(prayer)
        expect(Checkpoint.last_prayer(user.email)).to eq resident1.match_key
      end
    end
  end
end