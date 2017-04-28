class ListingDanceClasses
  def initialize(dance_class_finder = DanceClassFinder.new)
    @dance_class_finder = dance_class_finder
  end

  def days
    dance_classes = @dance_class_finder.by_day
    day_numbers.map { |day_number| Day.new(day_number, dance_classes[day_number]) }
  end

  private

  def day_numbers
    (0..6).to_a.rotate
  end

  class Day
    def initialize(day_number, dance_classes)
      @day_number = day_number
      @day_name = Date::DAYNAMES[day_number]
      @dance_classes = dance_classes
    end

    def as_id
      @day_name.downcase
    end

    def title
      @day_name
    end

    def classes
      @dance_classes
    end

    def today?
      Time.zone.today.wday == @day_number
    end
  end
end
