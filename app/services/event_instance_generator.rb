class EventInstanceGenerator
  def initialize(dates_calculator = DatesToGenerateCalculator.new, creator = EventInstancesCreator.new)
    @dates_calculator = dates_calculator
    @creator = creator
  end

  def call(event_period)
    dates_to_generate = @dates_calculator.dates(event_period)
    @creator.call(event_period.event_seed, dates_to_generate)
    Result.new(dates_to_generate)
  end
end

class EventInstanceGenerator::Result
  attr_reader :created_dates

  def initialize(created_dates)
    @created_dates = created_dates
  end
end
