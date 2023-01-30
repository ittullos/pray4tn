require './spec/spec_helper'

describe "Pastor4Life API -" do
  include Rack::Test::Methods
  let(:user) { User.scan.first }
  let(:start_checkpoint) {{ "checkpointData" => { "lat"    => random_location[0],
                                                  "long"   => random_location[1],
                                                  "type"   => "start",
                                                  "userId" => user.id }}}
  let(:heartbeat_checkpoint) {{ "checkpointData" => { "lat"    => random_location[0],
                                                      "long"   => random_location[1],
                                                      "type"   => "heartbeat",
                                                      "userId" => user.id }}}
  let(:prayer_checkpoint) {{ "checkpointData" => { "lat"    => random_location[0],
                                                   "long"   => random_location[1],
                                                   "type"   => "prayer",
                                                   "userId" => user.id }}}

  def app
    Sinatra::Application
  end

  def random_location
    RandomLocation.near_by(36.174465, -86.767960, 1000)
  end

  for i in 1..2 do
    User.new(
      email:    "email#{i}",
      password: "password#{i}"
    )
  end

  describe "Routes -" do
    let(:votd) { VERSES.first["scripture"] }

    context "Home -" do
      before do
        @home_data = { "userId" => "1"}
        clean_table(Checkpoint)
        clean_table(Route)
        clean_table(UserResident)
      end
      it "returns the correct verse" do
        post '/p4l/home', @home_data.to_json, "CONTENT_TYPE" => "application/json"
        expect(last_response.status).to eq(200)
        expect last_response.body.include?(votd)
      end
    end

    context "Checkpoint -" do
      before do
        clean_table(Checkpoint)
        clean_table(Route)
        clean_table(UserResident)
      end
        
      it "logs a start checkpoint" do
        route_count = Route.scan.count
        post '/p4l/checkpoint', start_checkpoint.to_json, "CONTENT_TYPE" => "application/json"
        expect(Route.scan.count).to eq(route_count + 1)
      end

      it "calulates the distance between checkpoints and send back the result" do
        post '/p4l/checkpoint', start_checkpoint.to_json, "CONTENT_TYPE" => "application/json"
        sleep 1
        post '/p4l/checkpoint', heartbeat_checkpoint.to_json
        expect(JSON.parse(last_response.body)["distance"]).to be > 0
      end
    end

    context "Prayer -" do
      before do
        clean_table(Checkpoint)
        clean_table(Route)
        clean_table(UserResident)
      end

      it 'returns nil when theres no data' do
        post '/p4l/checkpoint', prayer_checkpoint.to_json
        expect(JSON.parse(last_response.body)["prayerName"]).to eq("")
      end

      it 'returns a name if there is data' do
        resident = UserResident.new(name: "Steve", address: "101 Main st", user_id: user.id, match_key: "jhfsdlkhs")
        resident.save
        post '/p4l/checkpoint', prayer_checkpoint.to_json
        expect(JSON.parse(last_response.body)["prayerName"]).to eq("Steve")
      end
    end
  end
end