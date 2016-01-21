# Given a date in the past, return the next date which falls
# on the same day of the week
class WeeklyNextDateCalculator
  def next_date(start_date)
    date = OffsetDate.new(start_date)
    return date if date.today_or_in_the_future?

    Date.today + date.offset
  end

  class OffsetDate < SimpleDelegator
    def offset
      (self - Date.today) % 7

      # TODO: test this alternate approach for performance:
      # offset = ( ( @start_date.wday - Date.today.wday) % 7 )
    end

    def today_or_in_the_future?
      self >= Date.today
    end
  end
end
