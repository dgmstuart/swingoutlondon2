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
    if repeating?
      dates = [*0..3].map { |n| start_date + n.weeks }
    else
      dates = [start_date]
    end

    dates.each{ |date| EventInstance.create(event_seed: event_seed, date: date) }
    dates
  end
end
