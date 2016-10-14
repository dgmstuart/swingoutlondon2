class DatesToGenerateCalculator
  def dates(event_period)
    calculator = dates_calculator(event_period.repeating?)
    calculator.dates(event_period.start_date, event_period.end_date)
  end

  private

  def dates_calculator(repeating)
    if repeating
      WeeklyDatesCalculator.new
    else
      OneOffDateCalculator.new
    end
  end

  class OneOffDateCalculator
    def dates(one_date, _end_date)
      [one_date]
    end
  end

  class WeeklyDatesCalculator
    def initialize(next_date_calculator = WeeklyNextDateCalculator.new)
      @next_date_calculator = next_date_calculator
    end

    def dates(start_date, end_date, number_of_dates = 4)
      next_date = @next_date_calculator.next_date(start_date)
      [*0..number_of_dates - 1].map { |m| next_date + m.weeks }.reject { |d| d > end_date if end_date }
    end
  end
end
