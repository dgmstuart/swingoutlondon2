class EventPeriod < ActiveRecord::Base
  belongs_to :event_seed
  has_one :event, through: :event_seed
  has_many :event_instances, through: :event_seed

  validates :event_seed, presence: true
  validates :frequency, presence: true
  validates :start_date, presence: true,
                         date: {
                           after: proc { Time.zone.today - 6.months },
                           before: proc { Time.zone.today + 1.year },
                           allow_blank: true,
                           on: :create,
                         }

  def repeating?
    repeating_weekly?
  end

  def repeating_weekly?
    frequency == 1
  end

  def generate
    result = EventInstanceGenerator.new.call(self)
    result.created_dates
  end

  def self.generate_all
    all.find_each(&:generate)
  end
end
