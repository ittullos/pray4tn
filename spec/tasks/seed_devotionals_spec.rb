require 'spec_helper'
require_relative '../../lib/db_seed_devotionals'

RSpec.describe 'Seeding the database with devotionals', :task do
  let(:valid_attributes) { attributes_for(:devotional) }

  it 'creates the devotionals' do
    expect { SeedDevotionals.run }.to output(/Inserted 5 devotionals/).to_stdout

    expect(Devotional.count).to eq(5)

    devotional = Devotional.first
    expect(devotional.title).to include('Episode 1:')
  end
end
