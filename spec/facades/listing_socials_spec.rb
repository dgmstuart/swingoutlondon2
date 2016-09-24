require 'spec_helper'
require 'timecop'
require 'active_support/core_ext/time' # So we can use Time.zone.today
require 'active_support/core_ext/integer/inflections' # for #ordinalize
require 'app/facades/listing_socials'

RSpec.describe ListingSocials do
  class FakeSocialFinder
    def by_date
      []
    end
  end

  before do
    Time.zone = 'Europe/London'
    stub_const('SocialFinder', FakeSocialFinder)
  end

  describe '#dates' do
    it 'includes the socials for today' do
      today_socials = double('today socials')
      tomorrow_socials = double('tomorrow_socials')
      fake_social_finder = instance_double('SocialsFinder')
      allow(fake_social_finder).to receive(:by_date).and_return(
        Time.zone.today => today_socials,
        Time.zone.today + 1 => tomorrow_socials
      )
      item = described_class.new(fake_social_finder).dates.first
      expect(item.socials).to eq today_socials
    end

    it 'includes today if there are socials for today' do
      Timecop.freeze(Date.new(1983, 12, 23)) do
        fake_social_finder = instance_double('SocialsFinder')
        allow(fake_social_finder).to receive(:by_date).and_return(
          Time.zone.today => double("today's socials")
        )
        item = described_class.new(fake_social_finder).dates.first
        expect(item.as_id).to eq '1983-12-23'
        expect(item.title).to eq 'TODAY: Friday 23rd December'
      end
    end

    it 'includes the socials for tomorrow' do
      today_socials = double('today socials')
      tomorrow_socials = double('tomorrow_socials')
      fake_social_finder = instance_double('SocialsFinder')
      allow(fake_social_finder).to receive(:by_date).and_return(
        Time.zone.today => today_socials,
        Time.zone.today + 1 => tomorrow_socials
      )
      item = described_class.new(fake_social_finder).dates[1]
      expect(item.socials).to eq tomorrow_socials
    end

    it 'includes tomorrow if there are socials for tomorrow' do
      Timecop.freeze(Date.new(1983, 12, 23)) do
        fake_social_finder = instance_double('SocialsFinder')
        allow(fake_social_finder).to receive(:by_date).and_return(
          Time.zone.tomorrow => double("tomorrow's socials")
        )
        item = described_class.new(fake_social_finder).dates.first
        expect(item.as_id).to eq '1983-12-24'
        expect(item.title).to eq 'TOMORROW: Saturday 24th December'
      end
    end

    it 'includes the socials for next week' do
      today_socials = double('today socials')
      next_week_socials = double('next week socials')
      fake_social_finder = instance_double('SocialsFinder')
      allow(fake_social_finder).to receive(:by_date).and_return(
        Time.zone.today => today_socials,
        Time.zone.today + 7 => next_week_socials
      )
      item = described_class.new(fake_social_finder).dates[1]
      expect(item.socials).to eq next_week_socials
    end

    it 'includes a date next week if there are socials then' do
      Timecop.freeze(Date.new(1983, 12, 23)) do
        fake_social_finder = instance_double('SocialsFinder')
        allow(fake_social_finder).to receive(:by_date).and_return(
          Date.new(1983, 12, 30) => double("next week's socials")
        )
        item = described_class.new(fake_social_finder).dates.first
        expect(item.as_id).to eq '1983-12-30'
        expect(item.title).to eq 'Friday 30th December'
      end
    end
  end
end
