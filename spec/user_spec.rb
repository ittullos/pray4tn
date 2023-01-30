require './spec/spec_helper'

describe "User model - " do
  let(:valid_user_data) {
    { email: "validuser", password: "Frank" }
  }
  before do
    clean_table(User)
  end

  context "New User -" do
    it "assigns an id" do
      user = User.new_user(valid_user_data)
      expect(user.id).to_not be_nil
    end
  end

  context "Password Reset -" do
    it "resets the password" do
      User.new(valid_user_data).save
      user = User.find({email: "validuser"})
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
        user = User.find({email: "validuser"})
        expect(user.password).to eq("Frank")
      end
    end
  end
end