require 'rails_helper'

describe EventInstance, 'Associations', :type => :model do
  it { should belong_to(:event_seed) }
  it { should have_one(:event) }
  it { should belong_to(:venue) }
end

describe EventInstance, 'Validations', :type => :model do
  it { should validate_presence_of(:event_seed) }
  # it { should validate_presence_of(:date) } # Sufficiently covered by date validation?
  it "validates that date is a date"
end

describe EventInstance, :type => :model do
  let(:event_seed) { Fabricate.build(:event_seed) }
  [
    :url,
    :venue,
  ].each do | attribute |
    it "should inherit #{attribute} from the event seed" do
      event_instance = Fabricate.build(:event_instance, event_seed: event_seed, attribute => nil)
      expect(event_instance.public_send(attribute)).to eq event_seed.public_send(attribute)
    end
  end
end
