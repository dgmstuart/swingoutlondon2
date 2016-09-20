require 'rails_helper' # Because next_date + m.weeks doesn't work outside of rails, even with require 'active_support/core_ext/numeric/time'
require 'timecop'
require 'app/services/dates_to_generate_calculator'
require 'app/services/weekly_next_date_calculator' # because it's not possible to inject an instance

RSpec.describe DatesToGenerateCalculator do
  describe '#dates' do
    context 'when the period is a one-off' do
      it "returns just the one date (even if it's in the past)" do
        event_period = one_off_event_period(start_date: Time.zone.today - 1)
        expect(described_class.new.dates(event_period)).to eq [Time.zone.today - 1]
      end

      def one_off_event_period(start_date:)
        instance_double('EventPeriod', start_date: start_date, repeating?: false)
      end
    end

    context 'when the period is for a weekly repeating event' do
      let(:today) { Date.new(2001, 1, 1) }
      {
        'the start date is today' => Date.new(2001, 1, 1),
        'the start date is far in the past but on the same day' => Date.new(2001, 1, 1) - (52 * 7),
      }.each_pair do |context, start_date|
        it "returns 4 dates when #{context}" do
          Timecop.freeze(today) do
            event_period = weekly_event_period(start_date: start_date)
            expect(described_class.new.dates(event_period).map(&:day))
              .to eq [1, 8, 15, 22]
          end
        end
      end

      def weekly_event_period(start_date:)
        instance_double('EventPeriod', start_date: start_date, repeating?: true)
      end
    end
  end
end
