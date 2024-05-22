require 'spec_helper'

RSpec.describe Prayer, :model do
  describe 'associations' do
    it 'must have a user' do
      expect do
        build(:prayer, user: nil).save!
      end.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "must have a resident" do
      expect do
        build(:prayer, resident: nil).save!
      end.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "may have a route" do
      expect { build(:prayer, route: nil).save! }.not_to raise_error
    end
  end

  describe 'validations' do
    let(:attributes) { attributes_for(:prayer) }

    it 'is valid from the factory' do
      expect(create(:prayer)).to be_valid
    end
  end
end
