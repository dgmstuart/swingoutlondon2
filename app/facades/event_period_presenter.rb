class EventPeriodPresenter < SimpleDelegator
  def frequency_name
    {
      0 => 'Intermittent',
      1 => 'Weekly',
    }.fetch(frequency)
  end
end
