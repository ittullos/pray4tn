require 'spec_helper'

RSpec.describe Verse, :model do
  let (:valid_attributes) { attributes_for(:verse) }

  describe 'validations' do
    it 'is valid from the factory' do
      expect(described_class.new(valid_attributes)).to be_valid
    end

    it 'creates a valid list' do
      expect(create_list(:verse, 2).last).to be_valid
    end

    it 'requires a day' do
      verse = build(:verse, day: '')

      expect(verse).not_to be_valid
      expect(verse.errors.messages).to include(
        { day: ['can\'t be blank'] }
      )
    end

    it 'requires a scripture' do
      verse = build(:verse, scripture: '')

      expect(verse).not_to be_valid
      expect(verse.errors.messages).to include(
        { scripture: ['can\'t be blank'] }
      )
    end

    it 'requires a notation' do
      verse = build(:verse, notation: '')

      expect(verse).not_to be_valid
      expect(verse.errors.messages).to include(
        { notation: ['can\'t be blank'] }
      )
    end

    it 'requires a version' do
      verse = build(:verse, version: '')

      expect(verse).not_to be_valid
      expect(verse.errors.messages).to include(
        { version: ['can\'t be blank'] }
      )
    end

    it 'requires day to be unique' do
      first_verse = create(:verse)
      verse = build(:verse, day: first_verse.day)

      expect(verse).not_to be_valid
      expect(verse.errors.messages).to include(
        { day: ['has already been taken'] }
      )
    end
  end
end
