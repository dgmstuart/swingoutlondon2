require 'spec_helper'
require 'app/facades/event_period_presenter'

RSpec.describe EventPeriodPresenter do
  describe '#frequency_name' do
    it 'displays the frequency in text' do
      fake_period = instance_double('EventPeriod', frequency: 1)
      expect(EventPeriodPresenter.new(fake_period).frequency_name).to eq 'Weekly'
    end
  end
end
