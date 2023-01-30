require './spec/spec_helper'

describe UserResident do
  let(:user) { User.scan.first }
  let(:resident1) {{ name: "resident1", address: "address 1", user_id: user.id, match_key: "klfsdlfs;" }}
  let(:resident2) {{ name: "resident2", address: "address 2", user_id: user.id, match_key: "lkhfsldkj" }}

  it "returns the next name" do
    clean_table(UserResident)
    UserResident.new(resident1).save
    UserResident.new(resident2).save
    expect(UserResident.next_name(user.id)).to eq "resident1"
  end

end