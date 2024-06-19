require 'spec_helper'

RSpec.describe Resident, :model do
  describe 'validations' do
    let(:attributes) { attributes_for(:resident) }

    it 'is valid from the factory' do
      expect(create(:resident)).to be_valid
    end

    it 'validates a unique name' do
      create(:resident, name: 'Re-Pete')
      repeater = build(:resident, name: 're-pete')

      expect(repeater).not_to be_valid
      expect(repeater.errors.messages).to include(
        { name: ['has already been taken'] }
      )
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
