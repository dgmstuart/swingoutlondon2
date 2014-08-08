class EventGenerator < ActiveRecord::Base
  belongs_to :event_seed
  validates :frequency, presence: true
  validates :start_date, presence: true, date: {
    after: Proc.new { Date.today- 6.months },
    before: Proc.new { Date.today + 1.year },
    allow_blank: true
  }

  def repeating?
    return true if frequency == 1
    return false
  end

  def generate
    dates_to_generate.each do |date|
      EventInstance.create(event_seed: event_seed, date: date)
    end
    dates_to_generate
  end

  def dates_to_generate
    if repeating?
      dates = next_n_dates(start_date, 4)
    else
      dates = [start_date]
    end
  end

private

  def next_n_dates(start_date, n)
    [*0..n-1].map { |m| start_date + m.weeks }
  end
end
