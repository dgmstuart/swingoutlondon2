class DanceClassFinder
  def by_day
    DanceClass.all.group_by(&:day).tap { |h| h.default = [] }
  end
end
