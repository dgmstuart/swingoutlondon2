class EventsController < ApplicationController
  before_action :authenticate_user!

  # GET /events
  def index
    @events = Event.all.sorted
  end

  # GET /events/:id
  def show
    @event = Event.find(params[:id])
    @event_periods = @event.event_periods.order(start_date: :desc)
  end

  # GET /events/new
  def new
    @event_form = EventForm.new

    setup_venues
  end

  # POST /events
  def create
    form_params = event_form_params

    @create_venue = form_params.delete(:create_venue)
    form_params[:create_venue] = @create_venue

    venue_params = form_params.delete(:venue)
    form_params[:venue] = Venue.new(venue_params)

    @event_form = EventForm.new(form_params)

    if @event_form.valid?
      @event_form.venue.save! if @create_venue

      event = Event.new(
        name: @event_form.name
      )
      event_seed = EventSeed.new(
        event: event,
        url: @event_form.url,
        venue_id: @event_form.venue_id
      )
      event_period = EventPeriod.new(
        event_seed: event_seed,
        frequency: @event_form.frequency,
        start_date: @event_form.start_date,
      )

      event.save!
      event_seed.save!
      event_period.save!

      flash[:success] = "New event created"

      result = EventInstanceGenerator.new.call(event_period)
      dates = result.created_dates

      date_string = dates.map(&:to_s).join(", ") # TODO: Better way of doing this - in one step?
      flash[:success] += ". #{dates.count} instances created: #{date_string}"

      redirect_to event
    else
      setup_venues
      render :new
    end
  end

private

  def event_form_params
    params.require(:event_form).permit(
      :name,
      :url,
      :frequency,
      :start_date,
      :venue_id,
      :create_venue,
      venue: [ :name, :address, :postcode, :url ]
    )
  end

end
