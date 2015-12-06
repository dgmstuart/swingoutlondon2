class OrphanedEventsChecker
  def orphans(generator)
    generator.event_instances.select do |instance|
      !instance.date.between?(generator.start_date, generator.end_date)
    end
  end
end
