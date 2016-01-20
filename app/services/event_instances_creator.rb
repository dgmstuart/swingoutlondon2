class EventInstancesCreator
  def call(event_seed, dates)
    dates.each do |date|
      create_instance(event_seed, date)
    end
  end

  private def create_instance(event_seed, date)
    EventInstance.find_or_create_by!(
      event_seed: event_seed, date: date
    )
  end
end
