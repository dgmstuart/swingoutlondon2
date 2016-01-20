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

  private def dates_to_generate
    if repeating?
      WeeklyDatesToGenerateCalculator.new(start_date).dates(4)
    else
      OneOffDateCalculator.new(start_date).dates
    end
  end

  class OneOffDateCalculator
    def initialize(date)
      @date = date
    end

    def dates
      return [] if @date < Date.today
      [@date]
    end
  end

  class WeeklyNextDateCalculator
    def initialize(start_date)
      @start_date = start_date
    end

    def calculate
      return @start_date if starts_today_or_in_the_future?

      Date.today + offset
    end

    private def offset
      (@start_date - Date.today) % 7

      # TODO: test this alternate approach for performance:
      # offset = ( ( @start_date.wday - Date.today.wday) % 7 )
    end

    private def starts_today_or_in_the_future?
      @start_date >= Date.today
    end
  end

  class WeeklyDatesToGenerateCalculator
    def initialize(start_date)
      @next_date_calculator = WeeklyNextDateCalculator.new(start_date)
    end

    def dates(number_of_dates)
      [*0..number_of_dates-1].map { |m| next_date + m.weeks }
    end

    private def next_date
      @next_date_calculator.calculate
    end
  end
end
