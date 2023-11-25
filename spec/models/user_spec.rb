require 'spec_helper'

require './app/models/user'

RSpec.describe User, :model do
  let(:valid_attributes) do
    {
      first_name: 'Steven',
      last_name: 'Colbert',
      email: "sco'-lbert@gmail.com"
    }
  end

  describe 'validations' do
    it 'is valid from the factory' do
      expect(described_class.new(valid_attributes)).to be_valid
    end

    it 'requires a first_name' do
      attrs = valid_attributes.merge!(first_name: '')
      user = described_class.new(attrs)

      expect(user).not_to be_valid

      expect(user.errors.messages).to include(
        { first_name: ['can\'t be blank'] }
      )
    end

    it 'requires a last_name' do
      attrs = valid_attributes.merge!(last_name: '')
      user = described_class.new(attrs)

      expect(user).not_to be_valid
      expect(user.errors.messages).to include(
        { last_name: ['can\'t be blank'] }
      )
    end

    it 'requires an email' do
      attrs = valid_attributes.merge!(email: '')
      user = described_class.new(attrs)

      expect(user).not_to be_valid
      expect(user.errors.messages).to include(
        { email: ['can\'t be blank'] }
      )
    end

    it 'requires email to be unique' do
      described_class.new(valid_attributes).save
      second_user = described_class.new(valid_attributes)

      expect(second_user).not_to be_valid
      expect(second_user.errors.messages).to include(
        { email: ['has already been taken'] }
      )
    end
  end

  describe 'attributes' do
    subject { described_class.new(valid_attributes) }

    it 'has timestamps' do
      expect(subject.attributes).to include('created_at', 'updated_at')
    end
  end
end
