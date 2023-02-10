require_relative 'spec_helper'

describe Route do
  before do
    clean_table(Route)
  end
  
  context "#new_route" do
    it "creates a new route" do
      route = Route.new_route
      expect(route.id).to_not be_nil
    end
  end

  # Mock Checkpoint#user_checkpoints returns a list of checkpoint mocks
  # each checkpoint returns a distance of known value
  context "finalize" do
    xit "totals mileage" do

    end

    xit "totals seconds" do

    end

    xit "totals prayers" do

    end
  end
end