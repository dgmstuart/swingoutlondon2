require 'rails_helper'

RSpec.describe EventInstance, 'Associations', :type => :model do
  it { should belong_to(:event_seed) }
  it { should have_one(:event) }
  it { should belong_to(:venue) }
end

RSpec.describe EventInstance, 'Validations', :type => :model do
  it { should validate_presence_of(:event_seed) }
  it { should validate_presence_of(:date) }
  it "validates that date is a date" do
    generator = Fabricate.build(:event_period, start_date: Faker::Lorem.sentence)
    expect(generator).to be_invalid
  end
end

RSpec.describe EventInstance, 'Inheritance', :type => :model do
  let(:event_instance_attribute)         { event_instance.public_send(attribute) }
  let(:event_seed_attribute)  { event_instance.event_seed.public_send(attribute) }
  let(:event_attribute) { event_instance.event_seed.event.public_send(attribute) }
  [
    :url,
    :venue,
  ].each do | attrib |
    context "when #{attrib} is nil" do
      let(:attribute) { attrib }
      let(:event_instance) { Fabricate.build(:event_instance, attribute => nil) }
      it "should inherit #{attrib} from the event seed" do
        expect(event_instance_attribute).to eq event_seed_attribute
      end
    end
  end

  [
    :name,
  ].each do | attrib |
    context "when #{attrib} is nil" do
      let(:attribute) { attrib }
      # The has_many :through relationship doesn't work with built Fabricators, so it has to be created in the db
      let(:event_instance) { Fabricate.create(:event_instance) }
      it "should inherit #{attrib} from the event" do
        expect(event_instance_attribute).to eq event_attribute
      end
    end
  end
end
