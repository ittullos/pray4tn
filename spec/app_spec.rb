require './spec/spec_helper'

describe "Pastor4Life API - " do

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

  describe "Routes - " do
    let(:votd) { VERSES.first["scripture"] }

    context "Home route - " do
      it "returns the correct verse" do
        get '/p4l/home'
        expect(last_response.status).to eq(200)
        expect last_response.body.include?(votd)
      end
    end

    context "Checkpoint route - " do
        
      it "logs a start checkpoint" do

        route_count = Checkpoint.user_checkpoints(@user.id).start_points.count

        params = { :lat  => random_location[0],
                   :long => random_location[1],
                   :type => "start"}

        post '/p4l/checkpoint', params
        expect(Checkpoint.user_checkpoints(@user.id).start_points.count).to eq(route_count + 1)
      end
    end
  end
end
