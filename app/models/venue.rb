class Venue < ApplicationRecord
  include Sortable

  has_many :event_instances, inverse_of: :venue, dependent: :destroy
  has_many :event_seeds, inverse_of: :venue, dependent: :destroy
  has_many :dance_classes, dependent: :destroy # , inverse_of: :venue

  validates :name, presence: true, uniqueness: { allow_blank: true }
  validates :address, presence: true
  validates :postcode, presence: true
  validates :url, presence: true, url: { allow_blank: true }
end
