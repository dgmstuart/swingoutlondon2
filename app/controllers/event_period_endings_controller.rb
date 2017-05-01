class EventPeriodEndingsController < ApplicationController
  # TODO: Authenticate! - put in specs
  # before_action :authenticate_user!

  # GET /event/:event_id/event_periods/:event_period_id/endings/new
  def new
    @event = Event.find(params[:event_id])
    @event_period_ending = EventPeriodEnding.new(event: @event)
  end

  # POST /event/:event_id/event_periods/:event_period_id/endings
  def create
    old_event_period = EventPeriod.find(params[:event_period_id])

    @event_period_ending = EventPeriodEnding.new(
      event_period: old_event_period,
      end_date: event_period_ending_params[:end_date]
    )

    @event = Event.find(params[:event_id])

    if @event_period_ending.valid?
      EventPeriod.create!(
        start_date: @event_period_ending.end_date + 1,
        frequency: 0,
        event_seed: old_event_period.event_seed
      )
      redirect_to event_path(@event)
    else
      render :new
    end
  end

  private def event_period_ending_params
    params.require(:event_period_ending).permit(:end_date)
  end
end

class EventPeriodEnding
  include ActiveModel::Model
  attr_accessor :end_date
  attr_accessor :event
  attr_accessor :event_period

  validates :end_date, presence: true
  validates :end_date, date: { allow_blank: true }
  validate :end_date_is_after_start_date

  def end_date_is_after_start_date
    return unless event_period.start_date && end_date
    errors.add(:end_date, "can't be before start date (#{I18n.l event_period.start_date})") if end_date < event_period.start_date
  end

  def end_date=(date_string)
    @end_date = date_string.to_date if date_string
  end
end
