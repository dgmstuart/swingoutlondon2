# Given a date in the past, return the next date which falls
# on the same day of the week
class WeeklyNextDateCalculator
  def initialize(start_date)
    @start_date = start_date
  end

  def next_date
    return @start_date if starts_today_or_in_the_future?

    Date.today + offset
  end

  private def offset
    (@start_date - Date.today) % 7

    # TODO: test this alternate approach for performance:
    # offset = ( ( @start_date.wday - Date.today.wday) % 7 )
  end

  private def starts_today_or_in_the_future?
    @start_date >= Date.today
  end
end
