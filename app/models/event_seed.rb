class EventSeed < ApplicationRecord
  belongs_to :event, inverse_of: :event_seeds
  has_many :event_periods, inverse_of: :event_seed, dependent: :destroy
  has_many :event_instances, dependent: :destroy
  belongs_to :venue, inverse_of: :event_seeds

  accepts_nested_attributes_for :event_periods
  accepts_nested_attributes_for :venue

  validates :url, presence: true, url: { allow_blank: true }
  validates :event, presence: true
  validates :venue, presence: true
end
