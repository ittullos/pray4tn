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
  end
end
