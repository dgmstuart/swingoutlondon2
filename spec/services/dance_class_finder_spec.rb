require 'rails_helper'

RSpec.describe ListingDanceClasses::DanceClassFinder do
  describe '#by_day' do
    it 'raises no error' do
      expect { described_class.new.by_day }.to_not raise_error
    end

    it 'returns dance classes grouped by day' do
      monday_dance_class = Fabricate.create(:dance_class, day: 1)
      another_monday_dance_class = Fabricate.create(:dance_class, day: 1)
      wednesday_dance_class = Fabricate.create(:dance_class, day: 3)
      saturday_dance_class = Fabricate.create(:dance_class, day: 6)

      expected_result = {
        1 => [monday_dance_class, another_monday_dance_class],
        3 => [wednesday_dance_class],
        6 => [saturday_dance_class],
      }
      expect(described_class.new.by_day).to eq(expected_result)
    end

    it 'defaults to an empty list for weekday numbers' do
      (0..6).to_a.each do |day_number|
        expect(described_class.new.by_day[day_number]).to eq []
      end
    end
  end
end
