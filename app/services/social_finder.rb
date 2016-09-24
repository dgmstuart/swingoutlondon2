class SocialFinder
  def by_date
    EventInstance.all.group_by(&:date)
  end
end
