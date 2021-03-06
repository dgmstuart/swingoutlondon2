class Event < ActiveRecord::Base
  include Sortable

  has_many :event_seeds, inverse_of: :event
  has_many :event_periods, through: :event_seeds
  has_many :event_instances, through: :event_seeds

  accepts_nested_attributes_for :event_seeds

  validates :name, presence: true
  # TODO: - need to separately reject totally missing generators/seeds?
end
