class Venue < ActiveRecord::Base
  has_many :event_instances, inverse_of: :venue
  has_many :event_seeds, inverse_of: :venue
end