class PeriodsDoNotOverlap < ActiveModel::Validator
  def validate(record)
    validate_after_date(record.start_date, record.previous_period.end_date, 'the end date of the previous period', record.errors)
    validate_after_date(record.start_date, record.previous_period.start_date, 'the start date of the previous period', record.errors)
  end

  private

  def validate_after_date(date, reference_date, description, errors)
    return if reference_date.nil? || date > reference_date
    errors[:start_date] << "can't be before #{description} (#{I18n.l reference_date})"
  end
end

class EventPeriodAdder
  include ActiveModel::Validations
  attr_reader :new_period, :previous_period

  validates_with PeriodsDoNotOverlap

  delegate :start_date, :end_date, :errors, to: :new_period

  def initialize(new_period, previous_period)
    @new_period      = new_period
    @previous_period = previous_period
  end

  def add
    return false unless @new_period.valid? && valid?

    @new_period.save(validate: false)
    @previous_period.update_attributes!(end_date: start_date)
    true
  end
end

class NullEventPeriod
  def update_attributes!(attrs); end

  def start_date; end

  def end_date; end
end
