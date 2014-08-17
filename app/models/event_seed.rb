class EventSeed < ActiveRecord::Base
  belongs_to :event, inverse_of: :event_seeds
  has_many :event_generators, inverse_of: :event_seed
  has_many :event_instances
  belongs_to :venue

  accepts_nested_attributes_for :event_generators
  accepts_nested_attributes_for :venue

  validates :url, presence: true, url: { allow_blank: true }
  validates :venue, presence: true
end
