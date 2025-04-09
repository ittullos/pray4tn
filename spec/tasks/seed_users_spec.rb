require 'spec_helper'
require_relative '../../lib/db_seed_users'

RSpec.describe 'Seeding the database with users', :task do
  it 'creates the users' do
    expect { SeedUsers.run }.to output(/Inserted 1 users/).to_stdout

    expect(User.count).to eq(1)

    user = User.first
    expect(user.first_name).to eq 'Isaac'
  end
end
