class EventCreator
  def initialize(event_instance_generator = EventInstanceGenerator.new)
    @event_instance_generator = event_instance_generator
  end

  def call(event_form, create_venue)
    if event_form.valid?
      event_form.venue.save! if create_venue
      event = Event.create!(name: event_form.name)
      event_seed = EventSeed.create! \
        event: event,
        url: event_form.url,
        venue_id: event_form.venue_id
      event_period = EventPeriod.create! \
        event_seed: event_seed,
        frequency: event_form.frequency,
        start_date: event_form.start_date
      @event_instance_generator.call(event_period)
      Success.new(event)
    else
      Failure.new
    end
  end

  Success = Struct.new(:event) do
    def success?
      true
    end

    def message
      "New event created"
    end
  end

  class Failure
    def success?
      false
    end
  end
end
