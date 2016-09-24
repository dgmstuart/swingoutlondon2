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
  end
end
