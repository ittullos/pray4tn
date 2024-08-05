require 'spec_helper'

RSpec.describe 'Seeding the database with users', :task do
  #  let(:valid_attributes) { attributes_for(:user) }

  before(:all) do
    Rake.application.init
    Rake.application.load_rakefile
    Rake::Task.define_task(:environment)
    Rake::Task['db:seed:users'].invoke
  end

  it 'creates the users' do
    expect(User.count).to eq(1)
  end

  it 'creates the first user' do
    user = User.first
    expect(user.first_name).to eq 'Isaac'
  end
end
