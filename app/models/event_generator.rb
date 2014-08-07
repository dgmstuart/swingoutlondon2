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

    dates.each do |date|
      # TODO - move into event_seed
      event_seed_attributes = event_seed.attributes.tap { |x| x.delete "id" }
      event_instance = EventInstance.new(event_seed_attributes)
      event_instance.date = date
      event_instance.save!
    end
    dates
  end
end
