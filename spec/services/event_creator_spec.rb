require 'spec_helper'
require 'app/services/event_creator'

RSpec.describe EventCreator do
  context "when the event was intermittent and successfully created" do
    before { stub_models }

    it "creates an event with the given name" do
      event_klass = fake_event_klass
      stub_const("Event", event_klass)
      form = fake_event_form(name: "The Razmatazz club")

      described_class.new.call(form, false)

      expect(event_klass).to have_received(:create!).with(name: "The Razmatazz club")
    end

    it "creates an event seed with the given url and venue_id" do
      event_seed_klass = fake_event_seed_klass
      stub_const("EventSeed", event_seed_klass)
      form = fake_event_form \
        url: "http://consider.com/phlebas",
        venue_id: 17

      described_class.new.call(form, false)

      expect(event_seed_klass).to have_received(:create!)
        .with \
          url: "http://consider.com/phlebas",
          event: anything, # too complicated to test the specific value?
          venue_id: 17
    end

    it "creates an event instance with the given date" do
      event_instance_klass = fake_event_instance_klass
      stub_const("EventInstance", event_instance_klass)
      form = fake_event_form(start_date: Date.new(2012, 12, 23))

      described_class.new.call(form, false)

      expect(event_instance_klass).to have_received(:create!)
        .with \
          event_seed: anything, # too complicated to test the specific value?
          date: Date.new(2012, 12, 23)
    end

    it "creates a venue object if requested" do
      fake_venue = spy('Venue')
      form = fake_event_form(venue: fake_venue)

      described_class.new.call(form, true)

      expect(fake_venue).to have_received(:save!)
    end

    describe "result" do
      it "is successful" do
        expect(described_class.new.call(fake_event_form, false).success?).to eq true
      end

      it "returns a success message" do
        expect(described_class.new.call(fake_event_form, false).message).to eq "New event created"
      end

      it "returns the created event" do
        created_event = instance_double("Event")
        event_klass = fake_event_klass
        allow(event_klass).to receive(:create!).and_return(created_event)
        stub_const("Event", event_klass)

        expect(described_class.new.call(fake_event_form, false).event).to eq created_event
      end
    end
  end

  context "when there are validation errors" do
    describe "result" do
      it "is a failure" do
        fake_invalid_event_form = instance_double("EventForm", valid?: false)
        expect(described_class.new.call(fake_invalid_event_form, false).success?).to eq false
      end
    end
  end

  def fake_event_form(
    name: "The Black Cotton Club",
    start_date: Date.today,
    url: "https://google.com",
    venue_id: 34,
    venue: nil
  )
    instance_double("EventForm",
                    name: name,
                    start_date: start_date,
                    url: url,
                    venue_id: venue_id,
                    venue: venue,
                    valid?: true,
                   )
  end

  def stub_models
    stub_const("Event", fake_event_klass)
    stub_const("EventSeed", fake_event_seed_klass)
    stub_const("EventInstance", fake_event_instance_klass)
  end

  def fake_event_klass(created_event: nil)
    class_double("Event").tap do |event_klass|
      allow(event_klass).to receive(:create!)
    end
  end

  def fake_event_seed_klass
    class_double("EventSeed").tap do |event_seed_klass|
      allow(event_seed_klass).to receive(:create!)
    end
  end

  def fake_event_instance_klass
    class_double("EventInstance").tap do |event_instance_klass|
      allow(event_instance_klass).to receive(:create!)
    end
  end
end
