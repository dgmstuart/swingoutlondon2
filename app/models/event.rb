class Event < ActiveRecord::Base
  validates :url, presence: true, url: { allow_blank: true }
  validates :frequency, presence: true
  validates :date, presence: true, date: {
    after: Proc.new { Date.today- 6.months },
    before: Proc.new { Date.today + 1.year },
    allow_blank: true
  }

  def repeating?
    return true if frequency == 1
    return false
  end

  def generate
    raise "Can't generate non-repeating events" unless repeating?
    dates = [*1..3].map { |n| date + n.weeks }
    dates.each do |date|
      new_event = dup
      new_event.date = date
      new_event.save!
    end
    dates
  end
end