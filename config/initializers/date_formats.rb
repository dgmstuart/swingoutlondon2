Date::DATE_FORMATS[:casual] = lambda { |date| date.strftime "%A #{date.day.ordinalize} %B" }
