require 'spec_helper'
require 'app/services/event_creator'

RSpec.describe EventCreator do
  context "when the event was successfully created" do
    before do
      stub_const("Event", fake_event_klass)
      stub_const("EventSeed", fake_event_seed_klass)
      stub_const("EventPeriod", fake_event_period_klass)
      stub_const("EventInstanceGenerator", fake_event_instance_generator_klass)
    end


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

    it "creates an event period based on the given frequency and start date" do
      event_period_klass = fake_event_period_klass
      stub_const("EventPeriod", event_period_klass)
      form = fake_event_form \
        frequency: 4,
        start_date: Date.new(2012, 12, 23)

      described_class.new.call(form, false)

      expect(event_period_klass).to have_received(:create!)
        .with \
          event_seed: anything, # too complicated to test the specific value?
          frequency: 4,
          start_date: Date.new(2012, 12, 23)
    end

    it "generates some event instances based on the event period" do
      event_instance_generator = instance_double("EventInstanceGenerator")
      allow(event_instance_generator).to receive(:call).and_return Struct.new(:created_dates).new

      fake_event_period = instance_double("EventPeriod")
      allow(EventPeriod).to receive(:create!).and_return fake_event_period

      described_class.new(event_instance_generator).call(fake_event_form, false)

      expect(event_instance_generator).to have_received(:call).with(fake_event_period)
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

      context "when no instances were created" do
        it "returns a success message" do
          event_instance_generator = instance_double("EventInstanceGenerator")
          result = Struct.new(:created_dates).new([])
          allow(event_instance_generator).to receive(:call).and_return(result)

          result = described_class.new(event_instance_generator).call(fake_event_form, false)

          expect(result.message).to eq "New event created. No instances created."
        end
      end

      context "when one instance was created" do
        it "returns a success message" do
          event_instance_generator = instance_double("EventInstanceGenerator")
          result = Struct.new(:created_dates).new([Date.new(2012,12,22)])
          allow(event_instance_generator).to receive(:call).and_return(result)

          result = described_class.new(event_instance_generator).call(fake_event_form, false)

          expect(result.message).to eq "New event created. 1 instance created: 2012-12-22"
        end
      end

      context "when four instances were created" do
        it "returns a success message" do
          event_instance_generator = instance_double("EventInstanceGenerator")
          result = Struct.new(:created_dates).new([
            Date.new(2012,12,17),
            Date.new(2012,12,22),
            Date.new(2013,01,07),
            Date.new(2013,01,14),
          ])
          allow(event_instance_generator).to receive(:call).and_return(result)

          result = described_class.new(event_instance_generator).call(fake_event_form, false)

          expect(result.message).to eq "New event created. 4 instances created: 2012-12-17, 2012-12-22, 2013-01-07, 2013-01-14"
        end
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
        expect(described_class.new(double).call(fake_invalid_event_form, false).success?).to eq false
      end
    end
  end

  def fake_event_form(
    name: "The Black Cotton Club",
    start_date: Date.today,
    frequency: 0,
    url: "https://google.com",
    venue_id: 34,
    venue: nil
  )
    instance_double("EventForm",
                    name: name,
                    start_date: start_date,
                    frequency: frequency,
                    url: url,
                    venue_id: venue_id,
                    venue: venue,
                    valid?: true,
                   )
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

  def fake_event_period_klass
    class_double("EventPeriod").tap do |event_period_klass|
      allow(event_period_klass).to receive(:create!)
    end
  end

  def fake_event_instance_generator_klass
    class_double("EventInstanceGenerator").tap do |event_instance_generator_klass|
      fake_event_instance_generator = instance_double("EventInstanceGenerator")
      fake_result = Struct.new(:created_dates).new
      allow(fake_event_instance_generator).to receive(:call).and_return fake_result
      allow(event_instance_generator_klass).to receive(:new)
        .and_return fake_event_instance_generator
    end
  end
end
