require 'rails_helper'

RSpec.describe EventPeriod, 'Associations', type: :model do
  it { should belong_to(:event_seed) }
  it { should have_one(:event) }
  it { should have_many(:event_instances) }
end

RSpec.describe EventPeriod, 'Validations', type: :model do
  it { should validate_presence_of(:event_seed) }
  it { should validate_presence_of(:frequency) }
  it { should validate_presence_of(:start_date) }

  it 'validates that start_date is a date' do
    generator = Fabricate.build(:event_period, start_date: Faker::Lorem.sentence)
    expect(generator).to be_invalid
  end

  it 'validates that end_date is a date' do
    generator = Fabricate.build(:event_period, end_date: Faker::Lorem.sentence)
    expect(generator).to be_invalid
  end

  it 'validates that start_date is before end_date' do
    generator = Fabricate.build(:event_period, start_date: Time.zone.today, end_date: Faker::Date.backward)
    expect(generator).to be_invalid
  end
end

RSpec.describe EventPeriod, type: :model do
  describe '#repeating?' do
    {
      0 => false,
      1 => true,
      2 => false,
      4 => false,
      52 => false,
    }.each_pair do |frequency, result|
      context "when event frequency is #{frequency}" do
        let(:event_period) { Fabricate.build(:event_period, frequency: frequency) }
        it "returns #{result} " do
          expect(event_period.repeating?).to eql(result)
        end
      end
    end
  end

  describe '#generate' do
    let(:today) { Date.new(2001, 1, 1) }
    before { Timecop.freeze(today) }
    after { Timecop.return }

    context 'when an event is not repeating' do
      let(:event_period) { Fabricate.build(:event_period, frequency: 0, start_date: start_date) }

      context 'and the start_date is in the future' do
        let(:start_date) { today + 1 }
        it 'generates one event instance' do
          expect { event_period.generate }.to change { EventInstance.count }.by(1)
        end
      end

      context 'and the start_date is in the past' do
        let(:start_date) { today - 1 }
        it 'generates one event instance' do
          expect { event_period.generate }.to change { EventInstance.count }.by(1)
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
            expect { event_period.generate }.to change { EventInstance.count }.from(0).to(4)
          end
          it 'creates those event instances for the next 4 weeks' do
            event_period.generate
            expect(EventInstance.all.map(&:date)).to eq dates
          end
          it 'returns the dates it generated event instances for' do
            expect(event_period.generate).to eq dates
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
