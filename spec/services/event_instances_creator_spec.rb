require 'rails_helper'
require 'app/services/event_instances_creator'
require 'app/models/event_instance'

RSpec.describe EventInstancesCreator do
  it 'generates some instances' do
    event_seed = double('event_seed')

    expect(EventInstance).to receive(:find_or_create_by!).with(event_seed: event_seed, date: Time.zone.today)
    expect(EventInstance).to receive(:find_or_create_by!).with(event_seed: event_seed, date: Date.tomorrow)

    described_class.new.call(event_seed, [Time.zone.today, Date.tomorrow])
  end
end
