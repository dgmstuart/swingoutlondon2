class Event < ActiveRecord::Base
  has_many :event_seeds, inverse_of: :event
  has_many :event_periods, through: :event_seeds
  has_many :event_instances, through: :event_seeds

  accepts_nested_attributes_for :event_seeds

  # TODO: - need to separately reject totally missing generators/seeds?

  def name
    event_seeds.last.name
  end

  def self.sorted_by_name
    all.includes(:event_seeds).sort_by(&:name)
  end
end
