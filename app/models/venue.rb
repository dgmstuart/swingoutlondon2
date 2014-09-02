class Venue < ActiveRecord::Base
  include Sortable

  has_many :event_instances, inverse_of: :venue
  has_many :event_seeds, inverse_of: :venue
  has_many :dance_classes#, inverse_of: :venue
end