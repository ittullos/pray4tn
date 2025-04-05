require 'spec_helper'
require_relative '../../lib/db_seed_residents'

RSpec.describe 'Seeding the database with residents', :task do
  it 'creates the residents from the YAML file' do
    expect { SeedResidents.run }.to output(/Inserted 30 residents/).to_stdout

    expect(Resident.count).to eq(30)

    # Verify the first resident
    first_resident = Resident.find_by(name: "SpongeBob SquarePants")
    expect(first_resident).not_to be_nil
    expect(first_resident.user_id).to eq(3)

    # Verify the last resident
    last_resident = Resident.find_by(name: "Shaggy Rogers")
    expect(last_resident).not_to be_nil
    expect(last_resident.user_id).to eq(3)
  end

  it 'does not create duplicate residents' do
    # Run the seed task twice
    SeedResidents.run
    SeedResidents.run

    # Ensure no duplicates are created
    expect(Resident.count).to eq(30)
  end
end
