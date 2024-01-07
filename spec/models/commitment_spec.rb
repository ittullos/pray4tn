require 'spec_helper'
require 'active_support/testing/time_helpers'

RSpec.describe Commitment, :model do
  include ActiveSupport::Testing::TimeHelpers

  describe 'associations' do
    it 'belongs to a user' do
      expect do
        build(:commitment, user: nil).save!
      end.to raise_error(ActiveRecord::NotNullViolation)
    end
  end

  describe 'validations' do
    let(:today) { Date.new(2023, 11, 26) }
    let(:one_year_from_today) { today + 1.year }
    let(:tomorrow) { today + 1.day }
    let(:yesterday) { today - 1.day }
    let(:attributes) { attributes_for(:commitment).merge!(start_date: today) }

    it 'is valid from the factory' do
      expect(create(:commitment)).to be_valid
    end

    it 'must start before it ends' do
      commitment = Commitment.new(attributes.merge!(end_date: yesterday))
      expect(commitment).not_to be_valid
      expect(commitment.errors.messages).to include(
        end_date: ['must be greater than 2023-11-26']
      )
    end

    it 'sets default value for start_date alone' do
      travel_to(today) do
        commitment = Commitment.new(
          user: create(:user),
          end_date: Date.new(3000, 11, 26)
        )

        expect(commitment.start_date).to eq(today)
      end
    end

    it 'sets default values for end_date alone' do
      travel_to(today) do
        commitment = Commitment.new(
          user: create(:user),
          start_date: Date.new(3000, 11, 26)
        )

        expect(commitment.end_date).to eq(one_year_from_today)
      end
    end

    it 'sets default values for start_date and end_date' do
      travel_to(today) do
        commitment = Commitment.new(user: create(:user))

        expect(commitment.start_date).to eq(today)
        expect(commitment.end_date).to eq(one_year_from_today)
      end
    end
  end
end
