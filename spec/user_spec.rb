require './spec/spec_helper'

describe "User model - " do
  let(:valid_user_data) {
    { email: "valid@user.com", password: "Frank", commitment_id: 0 }
  }
  let(:user) { User.new_user(email: "email2",
    password: "password2", commitment_id: 0)}
  let(:start_checkpoint_data) {{ "recorded_at" => 1,
                                 "lat"     =>  35.952501574052484, 
                                 "long"    =>  -83.94271891950741,
                                 "type"    =>  "start",
                                 "user_id" =>  user.email}}
  let(:stop_checkpoint_data) {{ "recorded_at" => 100,
                                "lat"     =>  35.9600277485937, 
                                "long"    =>  -83.92067534459794,
                                "type"    =>  "stop",
                                "user_id" =>  user.email }}
  let(:heartbeat_checkpoint_data) {{ "recorded_at" => 3,
                                     "lat"     =>  35.95519313605983, 
                                     "long"    =>  -83.93591496691664,
                                     "type"    =>  "heartbeat",
                                     "user_id" =>  user.email }}
  let(:prayer_checkpoint_data) {{ "recorded_at" => 5,
                                  "lat"     =>  35.95741111360078, 
                                  "long"    =>  -83.93012698914711,
                                  "type"    =>  "prayer",
                                  "user_id" =>  user.email,
                                  "match_key" => "match_key" }}
  before do
    clean_table(User)
    clean_table(Checkpoint)
  end

  context "New User -" do
    it "assigns an id" do
      user = User.new_user(valid_user_data)
      expect(user.email).to_not be_nil
    end
  end

  context "Password Reset -" do
    it "resets the password" do
      User.new(valid_user_data).save
      user = User.find({email: "valid@user.com"})
      user.reset_password("new_password")
      expect(user.password).to eq("new_password")
    end
  end

  context "Find -" do
    context "When the user does not exist -" do
      it "returns nil" do
        user = User.find({email: "notauser"})
        expect(user).to be_falsey
      end
    end

    context "When the user exists -" do
      it "return the correct user" do
        User.new(valid_user_data).save
        user = User.find({email: "valid@user.com"})
        expect(user.password).to eq("Frank")
      end
    end
  end

  context "Stats -" do


    xcontext "Commitment -" do

    end

    context "All-Time -" do
      
      before do

        clean_table(Checkpoint)
        Checkpoint.new_checkpoint(start_checkpoint_data)
        sleep 1
        Checkpoint.new_checkpoint(heartbeat_checkpoint_data)
        sleep 1
        Checkpoint.new_checkpoint(prayer_checkpoint_data)
        sleep 1
        Checkpoint.new_checkpoint(heartbeat_checkpoint_data)
        sleep 1
        Checkpoint.new_checkpoint(prayer_checkpoint_data)
        sleep 1
        Checkpoint.new_checkpoint(heartbeat_checkpoint_data)
        sleep 1
        Checkpoint.new_checkpoint(stop_checkpoint_data)
        
      end
      
      it "calculates mileage" do
        user_stats = user.get_stats
        expect(user_stats[:all_time_miles]).to be_between(2,3)
      end
      it "calculates prayers" do
        user_stats = user.get_stats
        expect(user_stats[:all_time_prayers]).to be 2
      end
      it "calculates route time" do
        user_stats = user.get_stats
        expect(user_stats[:all_time_duration]).to be 6
      end
    end
  end
end