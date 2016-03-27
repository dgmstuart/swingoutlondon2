class EventCreator
  def call(event_form, create_venue)
    event = Event.create!(name: event_form.name)
    Result.new(true, event)
  end

  Result = Struct.new(:success?, :event) do
    def message
      "Event was successfully created"
    end
  end
end
