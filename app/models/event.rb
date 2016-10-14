class Event < ActiveRecord::Base
  include Sortable

  has_many :event_seeds, inverse_of: :event
  has_many :event_periods, through: :event_seeds
  has_many :event_instances, through: :event_seeds

  accepts_nested_attributes_for :event_seeds

  validates :name, presence: true
  # TODO: - need to separately reject totally missing generators/seeds?

  def current_event_period
    event_periods.order(start_date: :desc).find_by('start_date < ?', Date.new(2016,10,21))
  end
end
