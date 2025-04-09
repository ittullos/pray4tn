require 'spec_helper'

RSpec.describe Devotional, :model do
  let (:valid_attributes) { attributes_for(:devotional) }

  describe 'validations' do
    it 'is valid from the factory' do
      expect(described_class.new(valid_attributes)).to be_valid
    end

    it 'creates a valid list' do
      expect(create_list(:devotional, 2).last).to be_valid
    end

    it 'requires title' do
      devotional = build(:devotional, title: '')

      expect(devotional).not_to be_valid
      expect(devotional.errors.messages).to include(
        { title: ['can\'t be blank'] }
      )
    end

    it 'requires title to be unique' do
      create(:devotional, title: 'Daily Bread')
      devotional = build(:devotional, title: 'Daily Bread')

      expect(devotional).not_to be_valid
      expect(devotional.errors.messages).to include(
        { title: ['has already been taken'] }
      )
    end

    it 'requires url' do
      devotional = build(:devotional, url: '')

      expect(devotional).not_to be_valid
      expect(devotional.errors.messages).to include(
        { url: ['can\'t be blank'] }
      )
    end

    it 'requires img_url' do
      devotional = build(:devotional, img_url: '')

      expect(devotional).not_to be_valid
      expect(devotional.errors.messages).to include(
        { img_url: ['can\'t be blank'] }
      )
    end
  end
end
