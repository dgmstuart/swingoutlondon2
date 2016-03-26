class EventForm
  include ActiveModel::Validations
  include ActiveModel::Model

  attr_accessor :name
  attr_accessor :url
  attr_accessor :frequency
  attr_accessor :venue

  attr_accessor :create_venue

  attr_writer :start_date
  attr_writer :venue_id

  validates :name, presence: true
  validates :url, presence: true, url: { allow_blank: true }
  validates :frequency, presence: true
  validates :start_date, presence: true
  validate :start_date_isnt_too_old
  validate :start_date_isnt_too_far_future

  validates :venue_id, presence: true,  if: "!create_venue"
  validate :venue_is_valid, if: "create_venue"

  def venue_is_valid
    errors.add(:venue, "is invalid") unless venue && venue.valid?
  end

  def start_date_isnt_too_old
    return if start_date.nil?
    errors.add(:start_date, "can't be more than 6 months in the past") if start_date < Date.today - 183
  end

  def start_date_isnt_too_far_future
    return if start_date.nil?
    errors.add(:start_date, "can't be more than one year in the future") if start_date > Date.today + 365
  end

  def start_date
    return nil if @start_date.nil?
    Date.parse(@start_date)
  rescue ArgumentError
  end

  def venue_id
    return venue.id if create_venue && venue
    return nil if @venue_id.nil? || @venue_id.empty?
    @venue_id.to_i
  end
end
