class EventInstance < ActiveRecord::Base
  belongs_to :event_seed, inverse_of: :event_instances
  has_one :event, through: :event_seed
  belongs_to :venue, inverse_of: :event_instances

  validates :event_seed, presence: true
  validates :date, presence: true, date: { allow_blank: true }

  default_scope -> { order(date: :asc) }

  def name
    event.name
  end

  def url
    @url || event_seed.url
  end

  def venue
    @venue || event_seed.venue
  end
end
