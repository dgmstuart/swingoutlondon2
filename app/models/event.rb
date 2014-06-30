class Event < ActiveRecord::Base
  validates :url, presence: true
  validates :frequency, presence: true
  validates :date, presence: true

  def repeating?
    return true if frequency == 1
    return false
  end

  def generate
    raise "Can't generate non-repeating events" unless repeating?
    dates = [*1..3].map { |n| Date.today + n.weeks }
    dates.each do |date|
      new_event = dup
      # new_event.date = date
      new_event.save
    end
    dates.length
  end
end