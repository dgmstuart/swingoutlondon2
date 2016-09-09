class EventPeriod < ActiveRecord::Base
  belongs_to :event_seed
  has_one :event, through: :event_seed
  has_many :event_instances, through: :event_seed

  validates :event_seed, presence: true
  validates :frequency, presence: true
  validates :start_date, presence: true,
    date: {
      after: Proc.new { Date.today- 6.months },
      before: Proc.new { Date.today + 1.year },
      allow_blank: true,
      on: :create,
    }
  validates :end_date, date: { allow_blank: true }
  validate :end_date_is_after_start_date

  def end_date_is_after_start_date
    return unless start_date && end_date
    errors.add(:end_date, "can't be before start date (#{I18n.l start_date})") if end_date < start_date
  end

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
    all.each(&:generate)
  end
end
