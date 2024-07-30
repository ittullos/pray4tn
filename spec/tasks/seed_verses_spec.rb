require 'spec_helper'

RSpec.describe 'Seeding the database with verses', :task do
  let(:valid_attributes) { attributes_for(:verse) }

  before(:all) do
    Rake.application.init
    Rake.application.load_rakefile
    Rake::Task.define_task(:environment)
    Rake::Task['db:seed:verses'].invoke
  end

  it 'creates the verses' do
    expect(Verse.count).to eq(100)
  end

  it 'creates the first verse' do
    verse = Verse.first
    expect(verse.day).to eq 1
  end
end
