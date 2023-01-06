require './spec/spec_helper'

describe "Checkpoint model -" do

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before do 
    for i in 1..5 do
      User.insert(
        email: "email#{i}",
        password: "password#{i}"
      )
    end

    User.each do |user|
      for i in 1..7 do
        user.add_checkpoint(
          timestamp: Time.now.to_i,
          lat: random_location[0],
          long: random_location[1],
          type: "start"
        )
        for i in 1..6 do
          user.add_checkpoint(
            timestamp: Time.now.to_i,
            lat: random_location[0],
            long: random_location[1],
            type: "heartbeat"
          )
        end
        user.add_checkpoint(
          timestamp: Time.now.to_i,
          lat:       random_location[0],
          long:      random_location[1],
          type:      "stop"
        )
      end
    end

    @user = User.find(email: "email3")

    @user.add_checkpoint(
      timestamp: Time.now.to_i,
      lat: random_location[0],
      long: random_location[1],
      type: "start"
    )
    for i in 1..6 do
      @user.add_checkpoint(
        timestamp: Time.now.to_i,
        lat: random_location[0],
        long: random_location[1],
        type: "heartbeat"
      )
    end
  end

  describe "New checkpoint -" do
    context "Start -" do
      before do
        @route_count = Checkpoint.user_checkpoints(@user.id).start_points.count
        @user.add_checkpoint(timestamp: Time.now.to_i,
                             lat:       random_location[0],
                             long:      random_location[1],
                             type:      "start")                          
      end

      it "creates a new route" do
        expect(@route_count + 1).to eq(Checkpoint.user_checkpoints(@user.id).start_points.count)   
      end

      it "ends the previous route" do  
        expect(Checkpoint.user_checkpoints(@user.id).next_to_last.type).to eq("stop") 
      end
    end

    context "Heartbeat -" do
      it "associates checkpoint with the user's most recent route" do     
        checkpoint = @user.add_checkpoint(timestamp: Time.now.to_i,
                                          lat:       random_location[0],
                                          long:      random_location[1],
                                          type:      "heartbeat")
        expect(checkpoint.route_id).to eq(Checkpoint.user_checkpoints(@user.id).most_recent.route_id)
      end
    end

    context "Prayer Start -" do
      before do
        @route_count = Checkpoint.user_checkpoints(@user.id).start_points.count
        @user.add_checkpoint(timestamp:    Time.now.to_i,
                             lat:          random_location[0],
                             long:         random_location[1],
                             type:         "prayer_start")
      end

      it "creates a new prayer route if there is no route in progress" do
        expect(@route_count + 1).to eq(Checkpoint.user_checkpoints(@user.id).start_points.count)
      end

      it "sets the route type to 'prayer'" do
        expect(Checkpoint.user_checkpoints(@user.id).most_recent.route.type).to eq("prayer")
      end
    end

    context "Prayer -" do
      it "associates checkpoint with the user's most recent route" do     
        checkpoint = @user.add_checkpoint(timestamp: Time.now.to_i,
                                          lat:       random_location[0],
                                          long:      random_location[1],
                                          type:      "prayer")
        expect(checkpoint.route_id).to eq(Checkpoint.user_checkpoints(@user.id).most_recent.route_id)
      end
    end


    context "Stop -" do
      it "associates checkpoint with the user's most recent route" do
        checkpoint = @user.add_checkpoint(timestamp: Time.now.to_i,
                                          lat:       random_location[0],
                                          long:      random_location[1],
                                          type:      "stop")
        expect(checkpoint.route_id).to eq(Checkpoint.user_checkpoints(@user.id).most_recent.route_id)
      end

      it "calculates and fills in the route data" do 
        @start_checkpoint = @user.add_checkpoint(timestamp: TEST_ROUTE[0]["timestamp"],
                                                 lat:       TEST_ROUTE[0]["lat"],
                                                 long:      TEST_ROUTE[0]["long"],
                                                 type:      "start")
        @test_route_id = @start_checkpoint.route_id

        for i in 1..3 do
          @user.add_checkpoint(timestamp: TEST_ROUTE[i]["timestamp"],
                               lat:       TEST_ROUTE[i]["lat"],
                               long:      TEST_ROUTE[i]["long"],
                               type:      "heartbeat")
        end

        @user.add_checkpoint(timestamp: TEST_ROUTE[4]["timestamp"],
                             lat:       TEST_ROUTE[4]["lat"],
                             long:      TEST_ROUTE[4]["long"],
                             type:      "stop")
        expect(Route[@test_route_id].seconds).to eq(TEST_DURATION)
        expect(Route[@test_route_id].mileage).to eq(TEST_DISTANCE.to_i)
      end
    end
  end
end