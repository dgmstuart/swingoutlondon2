class EventInstance < ActiveRecord::Base
  belongs_to :event

  validates :date, presence: true, date: {
    after: Proc.new { Date.today- 6.months },
    before: Proc.new { Date.today + 1.year },
    allow_blank: true
  }
end
