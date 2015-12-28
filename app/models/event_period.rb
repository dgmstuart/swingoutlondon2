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
    dates_to_generate.select do |date|
      if not EventInstance.find_by(event_seed: event_seed, date: date)
        EventInstance.create!(event_seed: event_seed, date: date)
      else
        false
      end
    end
  end

  def next_date
    if starts_today_or_in_the_future?
      return start_date
    else
      return nil unless repeating?
    end

    offset = ( start_date - Date.today ) % 7
    Date.today + offset

    # TODO: test this alternate approach for performance:
    # offset = ( ( start_date.wday - Date.today.wday) % 7 )
  end

  def starts_today_or_in_the_future?
    start_date >= Date.today
  end

  def self.generate_all
    all.each(&:generate)
  end

private

  def dates_to_generate
    return [] if next_date.nil?
    if repeating?
      WeeklyDatesToGenerateCalculator.new.dates(next_date, 4)
    else
      [next_date]
    end
  end

  class WeeklyDatesToGenerateCalculator
    def dates(initial_date, number_of_dates)
      return [] if initial_date.nil?
      next_n_dates(initial_date, number_of_dates)
    end

    private def next_n_dates(initial_date, n)
      [*0..n-1].map { |m| initial_date + m.weeks }
    end
  end
end
