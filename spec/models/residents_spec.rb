require 'spec_helper'

RSpec.describe Resident, :model do
  describe 'validations' do
    let(:attributes) { attributes_for(:resident) }

    it 'is valid from the factory' do
      expect(create(:resident)).to be_valid
    end

    it 'does not allow duplicate names for the same user' do
      user = create(:user)

      create(:resident, name: 'Re-Pete', user: user)
      duplicate_resident = build(:resident, name: 're-pete', user: user)

      expect(duplicate_resident).not_to be_valid
      expect(duplicate_resident.errors.messages).to include(
        name: ['has already been taken']
      )
    end

    it 'allows duplicate names for different users' do
      user1 = create(:user)
      user2 = create(:user)

      create(:resident, name: 'Duplicate Name', user: user1)
      duplicate_resident = create(:resident, name: 'Duplicate Name', user: user2)

      expect(duplicate_resident).to be_valid
    end

    it 'sets default value for loaded_at' do
      resident = create(:resident, loaded_at: nil)

      expect(resident.loaded_at).not_to be_nil
    end

    it 'has a User' do
      expect(create(:resident).user).to be_a(User)
    end

    it 'acts as a list' do
      alice = create(:resident, name: 'Alice the first')
      bob = create(:resident, name: 'Bob the second')
      chad = create(:resident, name: 'Chad the third')
      create(:user, residents: [alice, bob, chad])

      expect(alice.next_resident).to eq(bob)
      expect(bob.next_resident).to eq(chad)
      expect(chad.next_resident).to eq(alice)
    end
  end
end
