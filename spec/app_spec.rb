require './spec/spec_helper'

describe "Pastor4Life - " do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before do 
    VERSES.each do |verse|
      Verse.insert(
        scripture: verse["scripture"],
        version: verse["version"],
        notation: verse["notation"]
      )
    end
  end

  it "canary in the coal mine" do
    get '/hello'
        expect(last_response.status).to eq(200)
  end

  describe "Database - " do
    context "Verses table - " do
      it "gets the first verse" do
        expect(Verse.first.notation).to eq(VERSES[0]["notation"])
      end
      # it "assigns the correct verse id" do
      #   expect(Verse.first[:id]).to eq 1
      # end
      # it "creates a new commitment" do
      #   expect(@account[:type]).to match(/savings/)
      # end
    end
  end

end
