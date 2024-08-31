require 'spec_helper'
require_relative '../../lib/db_seed_verses'

RSpec.describe 'Seeding the database with verses', :task do
  let(:valid_attributes) { attributes_for(:verse) }

  it 'creates the verses' do
    expect { SeedVerses.run }.to output(/Inserted 100 verses/).to_stdout

    expect(Verse.count).to eq(100)

    verse = Verse.first
    expect(verse.day).to eq 1
  end
end
