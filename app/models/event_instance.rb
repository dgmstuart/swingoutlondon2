class EventInstance < ActiveRecord::Base
  belongs_to :event_seed
  has_one :event, through: :event_seed
  belongs_to :venue

  validates :event_seed, presence: true
  validates :date, presence: true, date: {
    after: Proc.new { Date.today- 6.months },
    before: Proc.new { Date.today + 1.year },
    allow_blank: true
  }

  def url
    @url || event_seed.url
  end
  def venue
    @venue || event_seed.venue
  end

end
