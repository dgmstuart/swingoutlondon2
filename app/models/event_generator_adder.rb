class GeneratorsDoNotOverlap < ActiveModel::Validator
  def validate(record)
    validate_after_date(record.start_date, record.previous_generator.end_date, "the end date of the previous period", record.errors)
    validate_after_date(record.start_date, record.previous_generator.start_date, "the start date of the previous period", record.errors)
  end

  private def validate_after_date(date, reference_date, description, errors)
    unless reference_date.nil? || date > reference_date
      errors[:start_date] << "can't be before #{description} (#{reference_date})"
    end
  end
end


class EventGeneratorAdder
  include ActiveModel::Validations
  attr_reader :new_generator, :previous_generator

  validates_with GeneratorsDoNotOverlap

  delegate :start_date, :end_date, :errors, to: :new_generator

  def initialize(new_generator, previous_generator)
    @new_generator      = new_generator
    @previous_generator = previous_generator
  end

  def add
    return false unless @new_generator.valid? && valid?

    @new_generator.save(validate: false)
    @previous_generator.update_attributes!(end_date: start_date)
    return true
  end
end

class NullEventGenerator
  def update_attributes!(attrs); end
  def start_date; end
  def end_date; end
end
