require './spec/spec_helper'

describe Verse do

  before do
    clean_table(Verse)
    VERSES.each do |verse|
      Verse.new(
        day:       verse["day"],
        scripture: verse["scripture"],
        version:   verse["version"],
        notation:  verse["notation"]
      ).save
    end
  end

  context "verse retreival" do
    it "retreives a verse" do
      expect(Verse.scan.first.scripture).to match(VERSES[1]["scripture"])
    end
  end
end