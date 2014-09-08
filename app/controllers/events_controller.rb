class EventsController < ApplicationController
  before_action :authenticate_user!

  # GET /events
  def index
    @events = Event.all.sorted
  end

  # GET /events/:id
  def show
    @event = Event.find(params[:id])
  end

  # GET /events/new
  def new
    @create_event_form = CreateEventForm.new

    setup_venues
  end

  # POST /events
  def create
    @create_event_form = CreateEventForm.new

    if @create_event_form.create_event(create_event_params)

      flash[:success] = @create_event_form.success_message
      redirect_to @create_event_form.event, success:  @create_event_form.success_message
    else
      setup_venues
      render :new
    end
  end

private
  # TODO: Since we're using a form object, this might be redundant, but I'm not sure
  def create_event_params
    params.require(:event).permit(
      :name,
      :url,
      :frequency,
      :start_date,
      :venue_id,
      venue_attributes: [ :name, :address, :postcode, :url ]
    )
  end

end