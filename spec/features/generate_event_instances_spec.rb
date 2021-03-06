require 'rails_helper'

RSpec.describe EventInstanceGenerator do
  # NOTE: There's a unit test for this, but since it's called by a rake task,
  # an integration spec feels useful
  describe '#call' do
    let(:today) { Date.new(2001, 1, 1) }
    before { Timecop.freeze(today) }
    after { Timecop.return }

    context 'when an event is not repeating' do
      let(:event_period) { Fabricate.build(:event_period, frequency: 0, start_date: start_date) }

      context 'and the start_date is in the future' do
        let(:start_date) { today + 1 }
        it 'generates one event instance' do
          expect { EventInstanceGenerator.new.call(event_period) }.to change { EventInstance.count }.by(1)
        end
      end

      context 'and the start_date is in the past' do
        let(:start_date) { today - 1 }
        it 'generates one event instance' do
          expect { EventInstanceGenerator.new.call(event_period) }.to change { EventInstance.count }.by(1)
        end
      end
    end
    context 'when an event repeats weekly' do
      {
        'and the start date is today' => Date.new(2001, 1, 1),
        'and the start date is far in the past but on the same day' => Date.new(2001, 1, 1) - (52 * 7),
      }.each_pair do |context, start_date|
        context context do
          let(:event_period) { Fabricate.build(:event_period, frequency: 1, start_date: start_date) }
          let(:dates) do
            [
              today,
              Date.new(2001, 1, 8),
              Date.new(2001, 1, 15),
              Date.new(2001, 1, 22),
            ]
          end
          it 'creates 4 event instances' do
            expect { EventInstanceGenerator.new.call(event_period) }.to change { EventInstance.count }.from(0).to(4)
          end
          it 'creates those event instances for the next 4 weeks' do
            EventInstanceGenerator.new.call(event_period)
            expect(EventInstance.all.map(&:date)).to eq dates
          end
          it 'returns the dates it generated event instances for' do
            expect(EventInstanceGenerator.new.call(event_period).created_dates).to eq dates
          end
          it 'creates copies of the event seed' do
            # TODO: - find a better way to do this equality comparison
            EventInstance.all.each do |e|
              e.url = event.url
              e.venue_id = event.venue_id
            end
          end
        end
      end
    end
  end

  # describe ".generate_all" do # NOT TESTED - too trivial? https://stackoverflow.com/questions/25475252/how-to-test-a-rails-model-class-method-which-calls-a-method-on-all-members
end
