class DatesToGenerateCalculator
  def dates(event_period)
    calculator = dates_calculator(event_period.repeating?)
    calculator.dates(event_period.start_date)
  end

  private def dates_calculator(repeating)
    if repeating
      WeeklyDatesCalculator.new
    else
      OneOffDateCalculator.new
    end
  end

  private

  class OneOffDateCalculator
    def dates(date)
      return [] if date < Date.today
      [date]
    end
  end

  class WeeklyDatesCalculator
    def dates(start_date, number_of_dates = 4)
      next_date = WeeklyNextDateCalculator.new(start_date).next_date
      [*0..number_of_dates-1].map { |m| next_date + m.weeks }
    end
  end
end




