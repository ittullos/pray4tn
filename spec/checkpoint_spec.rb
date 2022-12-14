require './spec/spec_helper'

describe "Checkpoint model -" do

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def random_location
    RandomLocation.near_by(36.174465, -86.767960, 1000)
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
    context "Start - " do
      before do
        @route_count = @user.route_ids.count
        @user.add_checkpoint(timestamp: Time.now.to_i,
                            lat:       random_location[0],
                            long:      random_location[1],
                            type:      "start")                          
      end

      it "creates new route" do
        expect(@route_count + 1).to eq(@user.route_ids.count)   
      end

      it "ends the previous route" do  
        expect(Route[@user.prev_route_id].checkpoints.last.type).to eq("stop") 
      end
    end

    context "Heartbeat -" do
      it "associates checkpoint with the user's most recent route" do     
        checkpoint = @user.add_checkpoint(timestamp: Time.now.to_i,
                                          lat:       random_location[0],
                                          long:      random_location[1],
                                          type:      "heartbeat")
        expect(checkpoint.route_id).to eq(Route[@user.last_route_id].id)
      end
    end

    context "Stop -" do
      it "associates checkpoint with the user's most recent route" do
        checkpoint = @user.add_checkpoint(timestamp: Time.now.to_i,
                                          lat:       random_location[0],
                                          long:      random_location[1],
                                          type:      "stop")      
        expect(checkpoint.route_id).to eq(Route[@user.last_route_id].id)
      end
    end
  end
end