require 'spec_helper'
require 'services/orphaned_events_checker'

RSpec.describe OrphanedEventsChecker do
  describe '#orphans' do
    it 'returns an empty array when there are no events' do
      generator = double(event_instances: [])
      expect(OrphanedEventsChecker.new.orphans(generator)).to eq []
    end

    it 'returns an empty array when all events are within the range of the generator' do
      generator = double(
        start_date: Time.zone.today - 7,
        event_instances: [double(date: Time.zone.today)],
        end_date: Time.zone.today + 7
      )

      expect(OrphanedEventsChecker.new.orphans(generator)).to eq []
    end

    it 'returns a list of events which are outside the range' do
      orphan_before = double(date: Time.zone.today - 8)
      legit_instance = double(date: Time.zone.today)
      orphan_after = double(date: Time.zone.today + 8)
      generator = double(
        start_date: Time.zone.today - 7,
        end_date: Time.zone.today + 7,
        event_instances: [
          orphan_before,
          legit_instance,
          orphan_after,
        ]
      )

      expect(OrphanedEventsChecker.new.orphans(generator)).to eq [
        orphan_before,
        orphan_after,
      ]
    end
  end
end
