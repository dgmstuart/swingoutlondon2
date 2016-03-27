class EventCreator
  def call(event_form, create_venue)
    if event_form.valid?
      event = Event.create!(name: event_form.name)
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
