require 'spec_helper'

describe Event, 'Validations' do
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:frequency) }
  it { should validate_presence_of(:date) }
  it "validates that date is a date"
  it "validates that url is a url"
end

describe Event do
  describe "#repeating?" do
    {
      0 => false,
      1 => true,
      2 => false,
      4 => false,
      52 => false,
    }.each_pair do |frequency, result|
      context "when frequency is #{frequency}" do
        let(:event) { Fabricate.build(:event, frequency: frequency) }
        it "returns #{result} " do
          expect(event.repeating?).to eql(result)
        end
      end
    end
  end

  describe "#generate" do
    context 'when an event is not repeating' do
      let(:event) { Fabricate.build(:event, frequency: 0) }
      it "raises an error" do
        expect{ event.generate }.to raise_error
      end
    end
    context 'when an event repeats weekly' do
      let(:event) { Fabricate.build(:event, frequency: 1) }
      it "creates 3 events" do
        expect { event.generate }.to change{ Event.count }.from(0).to(3)
      end
      it "creates those events for the next 4 weeks"
      it "creates copies of the event" do
        # TODO - find a better way
        Event.all.each do |e|
          e.url = event.url
          e.frequency = event.frequency
        end
      end
      it "returns the number of events it created" do
        expect(event.generate).to eq 3
      end
    end
  end

end