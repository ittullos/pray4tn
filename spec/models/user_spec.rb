require 'spec_helper'

require './app/models/user'

RSpec.describe User, :model do
  let(:valid_attributes) { attributes_for(:user) }
  let(:user) { User.new(valid_attributes) }

  describe 'validations' do
    it 'is valid from the factory' do
      expect(described_class.new(valid_attributes)).to be_valid
    end

    it 'creates a valid list' do
      expect(create_list(:user, 2).last).to be_valid
    end

    it 'does not require a first_name' do
      user = build(:user, first_name: '')

      expect(user).to be_valid
    end

    it 'does not require a last_name' do
      user = build(:user, last_name: '')

      expect(user).to be_valid
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

  describe '#current_commitment' do
  it 'returns the most recent commitment' do
    create(:commitment, user: user, created_at: 1.day.ago)
    recent_commitment = create(:commitment, user: user, created_at: 1.hour.ago)
    expect(user.current_commitment).to eq(recent_commitment)
  end

  it 'returns nil if there are no commitments' do
    expect(user.current_commitment).to be_nil
  end
end
end
