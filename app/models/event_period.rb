class EventPeriod < ActiveRecord::Base
  belongs_to :event_seed
  has_one :event, through: :event_seed
  has_many :event_instances, through: :event_seed

  validates :event_seed, presence: true
  validates :frequency, presence: true
  validates :start_date, presence: true, date: {
    after: Proc.new { Date.today- 6.months },
    before: Proc.new { Date.today + 1.year },
    allow_blank: true,
    on: :create,
  }
  validates :end_date, date: {
    after: :start_date,
    allow_blank: true
  }

  def repeating?
    repeating_weekly?
  end

  def repeating_weekly?
    frequency == 1
  end

  def generate
    # TODO: SMELLY - this is a command method (does stuff) AND a query method (says what it did)
    # dates_to_generate.map do |date|
    #   EventInstance.find_or_create_by!(event_seed: event_seed, date: date)
    # end.map(&:date)
    result = EventInstanceGenerator.new.call(self)
    result.created_dates
  end

  def self.generate_all
    all.each(&:generate)
  end
end
