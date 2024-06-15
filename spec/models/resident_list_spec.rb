require 'spec_helper'

RSpec.describe ResidentList, :model do
  describe 'associations' do
    it 'must have a user' do
      expect do
        build(:resident_list, user: nil).save!
      end.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'can have Residents' do
      resident_list = create(:resident_list, :with_residents)
      expect(resident_list.residents.size).to eq(3)
      expect(resident_list.residents.first).to be_a(Resident)
    end
  end

  describe 'validations' do
    let(:attributes) { attributes_for(:resident_list) }

    it 'is valid from the factory' do
      expect(create(:resident_list)).to be_valid
    end
  end
end
