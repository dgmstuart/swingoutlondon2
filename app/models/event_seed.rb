class EventSeed < ActiveRecord::Base
  belongs_to :event
  has_many :event_generators
  has_many :event_instances

  accepts_nested_attributes_for :event_generators

  validates :url, presence: true, url: { allow_blank: true }
end
