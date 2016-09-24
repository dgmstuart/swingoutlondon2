require 'rails_helper'

RSpec.describe SocialFinder do
  describe '#by_date' do
    it 'returns an empty hash if there are no event instances' do
      expect(described_class.new.by_date).to eq({})
    end

    it 'returns socials for days which have them' do
      social_today = Fabricate.create(:event_instance, date: Time.zone.today)
      social_tomorrow = Fabricate.create(:event_instance, date: Time.zone.today + 1)
      another_social_tomorrow = Fabricate.create(:event_instance, date: Time.zone.today + 1)
      social_next_week = Fabricate.create(:event_instance, date: Time.zone.today + 7)

      expected_result = {
        Time.zone.today => [social_today],
        Time.zone.today + 1 => [social_tomorrow, another_social_tomorrow],
        Time.zone.today + 7 => [social_next_week],
      }
      expect(described_class.new.by_date).to eq(expected_result)
    end

    it 'only returns socials for the next 14 days' do
      _social_yesterday = Fabricate.create(:event_instance, date: Time.zone.yesterday)
      social_in_14_days = Fabricate.create(:event_instance, date: Time.zone.today + 13)
      _social_in_15_days = Fabricate.create(:event_instance, date: Time.zone.today + 14)

      expected_result = {
        Time.zone.today + 13 => [social_in_14_days],
      }
      expect(described_class.new.by_date).to eq(expected_result)
    end
  end
end
