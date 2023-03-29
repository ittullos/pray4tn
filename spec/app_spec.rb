require './spec/spec_helper'

describe "Pastor4Life API -" do
  include Rack::Test::Methods
  let(:user) { User.scan.first }
  let(:start_checkpoint) {{ "checkpointData" => { "lat"    => random_location[0],
                                                  "long"   => random_location[1],
                                                  "type"   => "start",
                                                  "user_id" => user.email }}}
  let(:heartbeat_checkpoint) {{ "checkpointData" => { "lat"    => random_location[0],
                                                      "long"   => random_location[1],
                                                      "type"   => "heartbeat",
                                                      "user_id" => user.email }}}
  let(:prayer_checkpoint) {{ "checkpointData" => { "lat"    => random_location[0],
                                                   "long"   => random_location[1],
                                                   "type"   => "prayer",
                                                   "user_id" => user.email }}}
  let(:journey_data) {{ "journeyData" => { "user_id" => user.email }}}
  let(:commitment_data) {{ "commitmentData" => { "user_id" => user.email ,
                                                 "journey_id" => "I-65 from Franklin to Nashville",
                                                 "target_date" => "2023-12-31" }}}

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
        resident = UserResident.new(name: "Steve", address: "101 Main st", user_id: user.email, match_key: "jhfsdlkhs")
        resident.save
        post '/p4l/checkpoint', prayer_checkpoint.to_json
        expect(JSON.parse(last_response.body)["prayerName"]).to eq("Steve")
      end
    end

    context 'Devotionals -' do
      before do
        clean_table(Devotional)
        devo = Devotional.new_devotional(
          id: 1,
          title: "Solid Joys Daily Devotional - Finally and Totally Justified (2/28)",
          url: "https://d1bxy2pveef3fq.cloudfront.net/episodes/original/22488574?episode_id=14092641&show_id=2747060&user_id=9300615&organization_id=9627600&tenant=SPREAKER&timestamp=1677598250&media_type=static&Expires=1677857450&Key-Pair-Id=K1J2BR3INU6RYD&Signature=L8UiK2aSDDi3djzz8E4XiL43thS8TJUjIH0iAtPrAfNj~1kXjz-uO0Rr8WF~dCmU8EgXZtooWBNDlQ21b4IywTXbMYygfeDz01KaF~ZLlvaqsOj-f2-M2~3g4RFTLMY2dhgJmgjDMoqTsbt4CdTBZCT5yVzzK11oTNK2VAKIUGOfzEXrHZPhlc0-hUS5hLqVvmO1gfE459gB1HKqldtuSk52Etd~FGH0DTyQGuli674KWLUgIrBn1oshF4edXZaPl0mD2tgC1xD~mSwzSLoOQ5shDmHH0UqNn6GbdNaqgoCbFDU4v6k8Mmgq46M8ZLoHHmd4PjnEraUNnih1B7LCfA__",
          img_url: "https://static.feedpress.com/logo/solid-joys-audio-5a0dd6d2592f3.png"
        )
        Devotional.new_devotional(
          id: 2,
          title: "Solid Joys Daily Devotional - God Opens the Heart (2/24)",
          url: "https://feed.desiringgod.org/link/18331/8373314/14092385.mp3",
          img_url: "https://static.feedpress.com/logo/solid-joys-audio-5a0dd6d2592f3.png"
        )
      end

      it 'returns all devotionals' do
        get '/p4l/devotionals'
        expect(JSON.parse(last_response.body)).not_to be_empty
        expect last_response.body.include?("Solid Joys")
      end
    end

    context 'Journeys -' do
      before do
        clean_table(Journey)
        Journey.new_journey(
          title: "I-65 from Franklin to Nashville",
          target_miles: 2150,
          graphic_url: "FranklinNashville"
        )
        Journey.new_journey(
          title: "I-40 accross the entire state",
          target_miles: 45528,
          graphic_url: "I40AcrossTN"
        )
      end
      it 'returns all journeys' do
        post '/p4l/journeys', journey_data.to_json, "CONTENT_TYPE" => "application/json"
        expect(JSON.parse(last_response.body)).not_to be_empty
        expect last_response.body.include?("Franklin to Nashville")
        expect(JSON.parse(last_response.body)["commitment"]).to eq "true"
      end
    end

    context 'Commitment -' do
      before do
        clean_table(User)
        clean_table(Commitment)
        @user2 = User.new_user(email:      "isaac.tullos@gmail.com",
                              password:   "1",
                              commitment_id: 0)

      end

      it 'creates a new commitment' do
        post '/p4l/commitment', commitment_data.to_json, "CONTENT_TYPE" => "application/json"
        @user2 = User.find(email: "isaac.tullos@gmail.com")
        expect(@user2.commitment_id).not_to eq 0
      end
    end
  end
end