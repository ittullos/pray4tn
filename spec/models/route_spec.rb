require 'spec_helper'

RSpec.describe Route, :model do
  describe 'associations' do
    it 'must have a user' do
      expect do
        build(:route, user: nil).save!
      end.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'may have a commitment' do
      expect { build(:route, commitment: nil).save! }.not_to raise_error
    end
  end

  describe 'validations' do
    let(:today) { DateTime.new(2023, 11, 26) }
    let(:one_year_from_today) { today + 1.year }
    let(:tomorrow) { today + 1.day }
    let(:yesterday) { today - 1.day }
    let(:attributes) { attributes_for(:route).merge!(started_at: today) }

    it 'is valid from the factory' do
      expect(create(:route)).to be_valid
    end
  end
end
