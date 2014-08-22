require 'rails_helper'

describe EventGenerator, 'Associations', :type => :model do
  it { should belong_to(:event_seed) }
  it { should have_one(:event) }
  it { should have_many(:event_instances) }
end

describe EventGenerator, 'Validations', :type => :model do
  it { should validate_presence_of(:event_seed) }
  it { should validate_presence_of(:frequency) }
  # it { should validate_presence_of(:date) } # Sufficiently covered by date validation?
  it "validates that date is a date"
end

describe EventGenerator, :type => :model do
  describe "#repeating?" do
    {
      0 => false,
      1 => true,
      2 => false,
      4 => false,
      52 => false,
    }.each_pair do |frequency, result|
      context "when event frequency is #{frequency}" do
        let(:event_generator) { Fabricate.build(:event_generator, frequency: frequency) }
        it "returns #{result} " do
          expect(event_generator.repeating?).to eql(result)
        end
      end
    end
  end

  describe "#generate" do
    context 'when an event is not repeating' do
      let(:event_generator) { Fabricate.build(:event_generator, frequency: 0) }
      let(:event_seed) { event_generator.event_seed }
      it "generates one event instance" do
        expect { event_generator.generate }.to change{ EventInstance.count }.from(0).to(1)
      end
      it "creates a copy of the event seed" do
        # TODO - find a better way to do this equality comparison
        event_generator.generate
        expect(EventInstance.first.url).to eq event_seed.url
        expect(EventInstance.first.venue).to eq event_seed.venue
      end
      it "returns the date it generated the event_instance for" do
        expect(event_generator.generate).to eq [event_generator.start_date]
      end

    end
    context 'when an event repeats weekly' do
      {
        "and the start date is today" => Date.new(2001,1,1),
        "and the start date is far in the past" => Date.new(2001,1,1) - (52*7),
        # "and the start date is a different date far in the past" => Date.new(2000,1,2),
      }.each_pair do |context, start_date|
        context context do
          before { Timecop.freeze(Date.new(2001, 1, 1)) }
          after { Timecop.return }
          let(:event_generator) { Fabricate.build(:event_generator, frequency: 1, start_date: start_date) }
          let(:dates) { [
              event_generator.start_date,
              Date.new(2001,1, 8),
              Date.new(2001,1,15),
              Date.new(2001,1,22),
            ]
          }
          it "creates 4 event instances" do
            expect { event_generator.generate }.to change{ EventInstance.count }.from(0).to(4)
          end
          it "creates those event instances for the next 4 weeks" do
            event_generator.generate
            expect( EventInstance.all.map(&:date) ).to eq dates
          end
          it "returns the dates it generated event instances for" do
            expect(event_generator.generate).to eq dates
          end
          it "creates copies of the event seed" do
            # TODO - find a better way to do this equality comparison
            EventInstance.all.each do |e|
              e.url = event.url
              e.venue_id = event.venue_id
            end
          end
        end
      end
    end
  end

  describe "#next_date" do
    subject(:next_date) { generator.next_date }
    let(:generator) { Fabricate.build(:event_generator, frequency: frequency, start_date: start_date) }

    let(:today) { Date.new(2001, 1, 23) }
    before { Timecop.freeze(today) }
    after { Timecop.return }

    context "when the event is not weekly" do
      let(:frequency) { 0 }
      context 'and the start_date is in the past' do
        let(:start_date) { today - 10 }
        it { is_expected.to be_nil }
      end
      context 'and the start_date is today' do
        let(:start_date) { today }
        it { is_expected.to eq today }
      end
      context 'and the start_date is in the future' do
        let(:start_date) { today + 10 }
        it { is_expected.to eq generator.start_date }
      end
    end

    context "when the event is weekly" do
      let(:frequency) { 1 }
      context "and the start_date is today" do
        let(:start_date) { today }
        it { is_expected.to eq today }
      end
      context 'and the start_date is in the future' do
        let(:start_date) { today + 10 }
        it { is_expected.to eq generator.start_date }
      end
      context 'and the start_date is one week ago today' do
        let(:start_date) { today - 7 }
        it { is_expected.to eq today }
      end
      context 'and the start_date is one week and one day ago' do
        let(:start_date) { today - 8 }
        let(:six_days_in_the_future) { today + 6 }
        it { is_expected.to eq six_days_in_the_future }
      end
      context 'and the start_date is one week less one day ago' do
        let(:start_date) { today - 6 }
        let(:tomorrow) { today + 1 }
        it { is_expected.to eq tomorrow }
      end

    end
  end

end


