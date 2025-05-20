require 'spec_helper'

RSpec.describe Route, :model do
  describe 'associations' do
    it 'must have a user' do
      expect do
        build(:route, user: nil).save!
      end.to raise_error(ActiveRecord::NotNullViolation)
    end

    it 'may have a commitment' do
      expect { build(:route, commitment: nil).save! }.not_to raise_error
    end
  end

  describe 'validations' do
    it 'validates mileage is an integer' do
      expect(build(:route, mileage: 'one hundred miles')).not_to be_valid
    end

    it 'validates seconds is an integer' do
      expect(build(:route, seconds: 'some')).not_to be_valid
    end

    it 'is valid from the factory' do
      expect(create(:route)).to be_valid
    end
  end

  describe 'methods' do
    let(:route) { create(:route, started_at: Time.current - 1.hour) }

    describe '#stop' do
      it 'sets stopped_at to the current time' do
        route.stop
        expect(route.stopped_at).not_to be_nil
        expect(route.stopped_at).to be_within(1.second).of(Time.current)
      end
    end

    describe '#calculate_route_time' do
      context 'when the route has not been started' do
        it 'raises an error' do
          route.update(started_at: nil)
          expect { route.calculate_route_time }.to raise_error(StandardError, 'Route has not been started!')
        end
      end

      context 'when the route is ongoing (not stopped)' do
        it 'calculates the time from started_at to the current time' do
          route.calculate_route_time
          expect(route.seconds).to eq(3600) # 1 hour in seconds
        end
      end

      context 'when the route has been stopped' do
        it 'calculates the time from started_at to stopped_at' do
          route.stop
          route.calculate_route_time
          expect(route.seconds).to eq((route.stopped_at - route.started_at).to_i)
        end
      end
    end
  end
end
