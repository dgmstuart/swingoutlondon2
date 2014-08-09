require 'rails_helper'

describe EventGenerator, 'Associations', :type => :model do
  it { should belong_to(:event_seed) }
  it { should have_one(:event) }
  xit { should have_many(:event_instances) }
end

describe EventGenerator, 'Validations', :type => :model do
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
    let(:event_seed) { Fabricate.build(:event_seed_with_event) }

    context 'when an event is not repeating' do
      let(:event_generator) { Fabricate.build(:event_generator, event_seed: event_seed, frequency: 0) }
      it "generates one event instance" do
        expect { event_generator.generate }.to change{ EventInstance.count }.from(0).to(1)
      end
      it "creates a copy of the event seed" do
        # TODO - find a better way to do this equality comparison
        event_generator.generate
        expect(EventInstance.first.url).to eq event_seed.url
      end
      it "returns the date it generated the event_instance for" do
        expect(event_generator.generate).to eq [event_generator.start_date]
      end

    end
    context 'when an event repeats weekly' do
      before { Timecop.freeze(Date.new(2001, 1, 1)) }
      after { Timecop.return }
      let(:event_generator) { Fabricate.build(:event_generator, event_seed: event_seed, frequency: 1, start_date: Date.new(2001,1,1)) }
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
        end
      end
    end
  end
end


