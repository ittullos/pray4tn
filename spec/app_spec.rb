require './spec/spec_helper'

describe "Pastor4Life - " do


  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def random_location
    RandomLocation.near_by(36.174465, -86.767960, 1000)
  end

  before do 

    VERSES.each do |verse|
      Verse.insert(
        scripture: verse["scripture"],
        version: verse["version"],
        notation: verse["notation"]
      )
    end

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
          lat: random_location[0],
          long: random_location[1],
          type: "stop"
        )
      end
    end

    @user = User.find(email: "email3")
    @new_checkpoint  = @user.add_checkpoint(timestamp: Time.now.to_i,
                                            lat: random_location[0],
                                            long: random_location[1],
                                            type: "start")
  end

  describe "Instance methods - " do
    context "Checkpoints - " do
      it "handles a start checkpoint" do
        route_count = @user.route_ids.count
        @user.add_checkpoint(timestamp: Time.now.to_i,
                             lat:       random_location[0],
                             long:      random_location[1],
                             type:      "start")

        expect(route_count + 1).to eq(@user.route_ids.count)
      end
      it "handles a heartbeat checkpoint" do     
        checkpoint = @user.add_checkpoint(timestamp: Time.now.to_i,
                                          lat:       random_location[0],
                                          long:      random_location[1],
                                          type:      "heartbeat")

        expect(checkpoint.route_id).to eq(Route[@user.last_route_id].id)
      end
    end
    
    context "Users - " do
      it "gets the user's route ids" do
        @route_ids = @user.route_ids
        expect(@route_ids.count).to eq(8)
      end
      it "gets the user's most recent route id" do
        @last_route_id = @user.last_route_id
        expect(@last_route_id).to eq(@new_checkpoint.route_id)
      end 
    end

    context
  end

  describe "API - " do
    let(:votd) { VERSES.first["scripture"] }

    context "Home route - " do
      it "returns the correct verse" do
        get '/p4l/home'
        expect(last_response.status).to eq(200)
        expect last_response.body.include?(votd)
      end
    end

    context "Checkpoint route - " do
        
      xit "logs a heartbeat checkpoint" do

        post '/p4l/checkpoint', params
        expect(User.first)
      end
    end
  end
end
