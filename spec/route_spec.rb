require_relative 'spec_helper'

describe Route do
  before do
    clean_table(Route)
    clean_table(Checkpoint)
  end
  
  context "#new_route" do
    let(:user) { User.scan.first }
    it "creates a new route" do
      route = Route.new_route(user.email)
      expect(route.id).to_not be_nil
    end
  end

  context "finalize" do
    let(:user) { User.scan.first }
    let(:start_checkpoint_data) {{ "recorded_at" => 1,
      "lat"     =>  35.962639,
      "long"    =>  -83.916718,
      "type"    =>  "start",
      "user_id" =>  user.email}}
    let(:heartbeat_checkpoint_data) {{ "recorded_at" => 3,
      "lat"     =>  35.961274,
      "long"    =>  -83.919856,
      "type"    =>  "heartbeat",
      "user_id" =>  user.email }}
    let(:prayer_checkpoint_data) {{ "recorded_at" => 5,
                                    "lat"    => 35.961274,
                                    "long"   => -83.919856,
                                    "type"   => "prayer",
                                    "user_id" => user.email }}
    let(:stop_checkpoint_data) {{ "recorded_at" => 100,
      "lat"     =>  35.958043,
      "long"    =>  -83.928058,
      "type"    =>  "stop",
      "user_id" =>  user.email }}
    before do
      clean_table(Route)
      clean_table(Checkpoint)
      clean_table(Commitment)
      @checkpoint = Checkpoint.new_checkpoint(start_checkpoint_data)
      sleep 1
      Checkpoint.new_checkpoint(heartbeat_checkpoint_data)
      sleep 1
      Checkpoint.new_checkpoint(prayer_checkpoint_data)
      sleep 1
      Checkpoint.new_checkpoint(stop_checkpoint_data)
    end

    it "totals mileage" do
      expect(Route.find(id: @checkpoint.route_id).mileage).to be_within(20).of(710)
    end

    it "totals seconds" do
      expect(Route.find(id: @checkpoint.route_id).seconds).to be > 0
    end

    it "totals prayers" do
      expect(Route.find(id: @checkpoint.route_id).prayer_count).to eq 1
    end

    it "saves correct commitment_id" do
      expect(Route.find(id: @checkpoint.route_id).commitment_id).to eq 1
    end
  end
end