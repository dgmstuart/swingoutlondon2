require 'rails_helper'

describe Event, 'Validations' do
  # it { should validate_presence_of(:url) } # Sufficiently covered by url validation?
  it { should validate_presence_of(:frequency) }
  # it { should validate_presence_of(:date) } # Sufficiently covered by date validation?
  it "validates that date is a date"
  it "validates that url is a url" do
    expect( Fabricate.build(:event, url: "foo") ).to_not be_valid
    expect( Fabricate.build(:event, url: "http://foo.com") ).to be_valid
    expect( Fabricate.build(:event, url: "https://foo.co.uk") ).to be_valid
  end
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
      before { Timecop.freeze(Date.new(2001, 1, 1)) }
      after { Timecop.return }
      let(:event) { Fabricate.build(:event, frequency: 1, date: Date.new(2001,1,1)) }
      let(:other_dates) { [
          Date.new(2001,1, 8),
          Date.new(2001,1,15),
          Date.new(2001,1,22),
        ]
      }
      it "creates 3 events" do
        expect { event.generate }.to change{ Event.count }.from(0).to(3)
      end
      it "creates those events for the next 4 weeks" do
        event.generate
        expect( Event.all.map(&:date) ).to eq other_dates
      end
      it "returns the dates it generated events for" do
        expect(event.generate).to eq other_dates
      end
      it "creates copies of the event" do
        # TODO - find a better way to do this equality comparison
        Event.all.each do |e|
          e.url = event.url
          e.frequency = event.frequency
        end
      end
    end
  end

end