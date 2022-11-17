require './spec/spec_helper'

describe "Verses - " do

  before do
    VERSES.each do |verse|
      Verse.insert(
        scripture: verse["scripture"],
        version: verse["version"],
        notation: verse["notation"]
      )
    end
  end

  context "verse retreival" do
    it "retreives a verse" do
      expect(Verse.first.scripture).to match(VERSES[0]["scripture"])
    end
  end
end