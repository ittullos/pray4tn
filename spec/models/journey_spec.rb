require 'spec_helper'

RSpec.describe Journey, :model do
  let (:valid_attributes) { attributes_for(:journey) }

  describe 'validations' do
    it 'is valid from the factory' do
      expect(described_class.new(valid_attributes)).to be_valid
    end

    it 'creates a valid list' do
      expect(create_list(:journey, 2).last).to be_valid
    end

    it 'requires annual_miles' do
      journey = build(:journey, annual_miles: '')

      expect(journey).not_to be_valid
      expect(journey.errors.messages).to include(
        { annual_miles: ['can\'t be blank', 'is not a number'] }
      )
    end

    it 'requires annual_miles to be a number' do
      journey = build(:journey, annual_miles: 'abc')

      expect(journey).not_to be_valid
      expect(journey.errors.messages).to include(
        { annual_miles: ['is not a number'] }
      )
    end

    it 'requires monthly_miles' do
      journey = build(:journey, monthly_miles: '')

      expect(journey).not_to be_valid
      expect(journey.errors.messages).to include(
        { monthly_miles: ['can\'t be blank', 'is not a number'] }
      )
    end

    it 'requires monthly_miles to be a number' do
      journey = build(:journey, monthly_miles: 'abc')

      expect(journey).not_to be_valid
      expect(journey.errors.messages).to include(
        { monthly_miles: ['is not a number'] }
      )
    end

    it 'requires weekly_miles' do
      journey = build(:journey, weekly_miles: '')

      expect(journey).not_to be_valid
      expect(journey.errors.messages).to include(
        { weekly_miles: ['can\'t be blank', 'is not a number'] }
      )
    end

    it 'requires weekly_miles to be a number' do
      journey = build(:journey, weekly_miles: 'abc')

      expect(journey).not_to be_valid
      expect(journey.errors.messages).to include(
        { weekly_miles: ['is not a number'] }
      )
    end

    it 'requires a title' do
      journey = build(:journey, title: '')

      expect(journey).not_to be_valid
      expect(journey.errors.messages).to include(
        { title: ['can\'t be blank'] }
      )
    end

    it 'requires a unique title' do
      first_journey = create(:journey)
      journey = build(:journey, title: first_journey.title)

      expect(journey).not_to be_valid
      expect(journey.errors.messages).to include(
        { title: ['has already been taken'] }
      )
    end
  end

  describe '#next_journey' do
    let!(:j1) { create(:journey, annual_miles: 1000) }
    let!(:j2) { create(:journey, annual_miles: 2000) }
    let!(:j3) { create(:journey, annual_miles: 3000) }

    it 'returns the next journey with higher annual_miles' do
      expect(j1.next_journey).to eq(j2)
      expect(j2.next_journey).to eq(j3)
    end

    it 'returns nil if there is no next journey' do
      expect(j3.next_journey).to be_nil
    end
  end
end
