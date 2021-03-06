class ListingSocials
  def initialize(social_finder = SocialFinder.new)
    @social_finder = social_finder
  end

  def dates
    @social_finder.by_date.reduce([]) do |socials_dates, (date, socials)|
      socials_dates << SocialsDate.new(date, socials)
    end
  end

  class SocialsDate
    attr_reader :socials
    def initialize(date, socials)
      @date = date
      @socials = socials
    end

    def as_id
      @date.iso8601
    end

    def title
      return "TODAY: #{formatted_date}" if today?
      return "TOMORROW: #{formatted_date}" if tomorrow?
      formatted_date
    end

    def today?
      @date == Time.zone.today
    end

    def tomorrow?
      @date == Time.zone.tomorrow
    end

    private

    def formatted_date
      @date.strftime("%A #{@date.day.ordinalize} %B")
    end
  end
end
