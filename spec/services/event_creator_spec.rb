require 'spec_helper'
require 'app/services/event_creator'

RSpec.describe EventCreator do
  it "creates an event with the given name" do
    event_klass = fake_event_klass
    stub_const("Event", event_klass)
    form = fake_event_form(name: "The Razmatazz club")

    described_class.new.call(form, anything)

    expect(event_klass).to have_received(:create!).with(name: "The Razmatazz club")
  end

  it "returns a successful result" do
    stub_event_klass

    expect(described_class.new.call(fake_event_form, anything).success?).to eq true
  end

  it "returns a success message" do
    stub_event_klass

    expect(described_class.new.call(fake_event_form, anything).message).to eq "Event was successfully created"
  end

  it "returns the created event" do
    created_event = instance_double("Event")
    event_klass = fake_event_klass
    allow(event_klass).to receive(:create!).and_return(created_event)
    stub_const("Event", event_klass)

    expect(described_class.new.call(fake_event_form, anything).event).to eq created_event
  end

  def fake_event_form(name: "The Black Cotton Club")
    instance_double("EventForm", name: name)
  end

  def stub_event_klass
    stub_const("Event", fake_event_klass)
  end

  def fake_event_klass(created_event: nil)
    class_double("Event").tap do |event_klass|
      allow(event_klass).to receive(:create!)
    end
  end
end
