class Event < ActiveRecord::Base
  include Sortable

  has_many :event_seeds, inverse_of: :event
  has_many :event_generators, through: :event_seeds
  has_many :event_instances, through: :event_seeds

  validates :name, presence: true
  # TODO - need to separately reject totally missing generators/seeds?
end
