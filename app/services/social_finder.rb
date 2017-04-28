class SocialFinder
  def by_date
    EventInstance.where(date: date_range).includes(:event_seed).group_by(&:date)
  end

  private

  def date_range
    first_date..last_date
  end

  def first_date
    Time.zone.today
  end

  def last_date
    first_date + 13
  end
end
