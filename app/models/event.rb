class Event < ActiveRecord::Base
  has_many :event_seeds, inverse_of: :event
  has_many :event_periods, through: :event_seeds
  has_many :event_instances, through: :event_seeds

  accepts_nested_attributes_for :event_seeds

  # TODO: - need to separately reject totally missing generators/seeds?

  def name
    current_event_seed.name
  end

  def self.sorted_by_name
    all.includes(:event_seeds).sort_by(&:name)
  end

  private

  def current_event_seed
    current_event_period.event_seed
  end

  def current_event_period
    current_query = 'start_date <= :today AND end_date >= :today'
    future_query = ''
    past_query = ''
    event_periods.where("(#{current_query}) OR (#{past_query}) OR (#{future_query})")
  end

  def latest_event_period
    event_periods.where('end_date >= ?', Time.zone.today).maximum(:end_date)
  end

  # approach: if we're in one, use that, else look for the next one if there is one, else look for the last one if there is one
end
