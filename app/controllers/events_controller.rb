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

    @create_venue = form_params[:create_venue]

    venue_params = form_params.delete(:venue)
    form_params[:venue] = Venue.new(venue_params)

    @event_form = EventForm.new(form_params)

    result = EventCreator.new.call(@event_form, @create_venue)
    if result.success?
      flash[:success] = result.message
      redirect_to result.event
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
