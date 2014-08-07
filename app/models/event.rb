class Event < ActiveRecord::Base
  has_many :event_seeds
  has_many :event_generators, through: :event_seeds
  has_many :event_instances

  accepts_nested_attributes_for :event_seeds

  validates :name, presence: true
  # TODO - need to separately reject totally missing generators/seeds?
end