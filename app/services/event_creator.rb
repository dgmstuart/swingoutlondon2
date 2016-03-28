class EventCreator
  def call(event_form, create_venue)
    if event_form.valid?
      event = Event.create!(name: event_form.name)
      event_seed = EventSeed.create! \
        event: event,
        url: event_form.url,
        venue_id: event_form.venue_id
      EventInstance.create! \
        event_seed: event_seed,
        date: event_form.start_date
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
