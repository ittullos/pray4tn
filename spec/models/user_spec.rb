require 'spec_helper'

require './app/models/user'

RSpec.describe User, :model do
  let(:valid_attributes) { attributes_for(:user) }

  describe 'validations' do
    it 'is valid from the factory' do
      expect(described_class.new(valid_attributes)).to be_valid
    end

    it 'creates a valid list' do
      expect(create_list(:user, 2).last).to be_valid
    end

    it 'requires a first_name' do
      user = build(:user, first_name: '')

      expect(user).not_to be_valid
      expect(user.errors.messages).to include(
        { first_name: ['can\'t be blank'] }
      )
    end

    it 'requires a last_name' do
      user = build(:user, last_name: '')

      expect(user).not_to be_valid
      expect(user.errors.messages).to include(
        { last_name: ['can\'t be blank'] }
      )
    end

    it 'requires an email' do
      user = build(:user, email: '')

      expect(user).not_to be_valid
      expect(user.errors.messages).to include(
        { email: ['can\'t be blank'] }
      )
    end

    it 'requires email to be unique' do
      first_user = create(:user)
      user = build(:user, email: first_user.email)

      expect(user).not_to be_valid
      expect(user.errors.messages).to include(
        { email: ['has already been taken'] }
      )
    end

    it 'requires a sub' do
      user = build(:user, sub: '')

      expect(user).not_to be_valid
      expect(user.errors.messages).to include(
        { sub: ['can\'t be blank'] }
      )
    end

    it 'requires sub to be unique' do
      first_user = create(:user)
      user = build(:user, sub: first_user.sub)

      expect(user).not_to be_valid
      expect(user.errors.messages).to include(
        { sub: ['has already been taken'] }
      )
    end
  end

  describe 'attributes' do
    subject { described_class.new(valid_attributes) }

    it 'has timestamps' do
      expect(subject.attributes).to include('created_at', 'updated_at')
    end
  end
end
