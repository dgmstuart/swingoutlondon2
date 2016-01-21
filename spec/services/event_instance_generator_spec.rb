require 'spec_helper'
require 'app/services/event_instance_generator'

RSpec.describe EventInstanceGenerator do
  it "generates instances based on the event period" do
    event_seed = double(:event_seed)
    event_period = fake_event_period(event_seed: event_seed)

    creator = double("EventInstanceCreator")
    expect(creator).to receive(:call).with(event_seed, anything)

    described_class.new(fake_date_calculator, creator).call(event_period)
  end

  it "generates instances for dates defined by the event period" do
    event_period = fake_event_period

    date_calculator = instance_double("DatesToGenerateCalculator")
    expect(date_calculator).to receive(:dates).with(event_period).and_return [Date.tomorrow]

    creator = double("EventInstanceCreator")
    expect(creator).to receive(:call).with(anything, [Date.tomorrow])

    described_class.new(date_calculator, creator).call(event_period)
  end

  describe "Result:" do
    it "returns a result with the created dates" do
      date_calculator = instance_double("DatesToGenerateCalculator", dates: [Date.tomorrow + 1])

      generator = described_class.new(date_calculator, fake_creator)
      expect(generator.call(fake_event_period).created_dates).to eq [Date.tomorrow + 1]
    end
  end

  def fake_event_period(event_seed: double)
    instance_double("EventPeriod", event_seed: event_seed)
  end

  def fake_date_calculator
    instance_double("DatesToGenerateCalculator").tap do |date_calculator|
      allow(date_calculator).to receive(:dates)
    end
  end

  def fake_creator
    instance_double("EventInstanceCreator").tap do |creator|
      allow(creator).to receive(:call)
    end
  end
end
