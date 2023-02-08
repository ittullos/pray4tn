require './spec/spec_helper'

describe UserResident do
  let(:user) { User.new_user(email: "email", password: "password") }
  let(:resident1) {{ name: "resident1", address: "address 1", user_id: user.email, match_key: "alfsdlfs;" }}
  let(:resident2) {{ name: "resident2", address: "address 2", user_id: user.email, match_key: "lkhfsldkj" }}
  let(:prayer) {{ timestamp: Time.now.to_i,
                  lat:       random_location[0],
                  long:      random_location[1],
                  type:      "prayer",
                  user_id:   user.email,
                  match_key: resident1[:match_key] }}

  before do
    clean_table(UserResident)
    clean_table(Checkpoint)
    clean_table(User)
  end

  context "When there are names" do
    context "When no prayers have been made" do
      it "returns the first name" do
        UserResident.new(resident1).save
        UserResident.new(resident2).save
        expect(UserResident.next_resident(user.email).name).to eq "resident1"
      end
    end

    context "When prayers have been made" do
      it "returns the next prayer name" do
        UserResident.new(resident1).save
        UserResident.new(resident2).save
        Checkpoint.new_checkpoint(prayer)
        expect(UserResident.next_resident(user.email).name).to eq resident2[:name]
      end
    end
  end

  context "When there are no names" do
    it "returns an empty string" do
      expect(UserResident.next_resident(user.email)).to be_nil
    end
  end

  context "When all names have been prayed for" do
    it "returns the first prayer name" do
      UserResident.new(resident2).save
      UserResident.new(resident1).save
      Checkpoint.new_checkpoint(prayer)
      expect(UserResident.next_resident(user.email).name).to eq resident2[:name]
    end
  end
end