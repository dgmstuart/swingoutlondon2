class EventsController < ApplicationController
  # GET /events
  def index
    @events = Event.all
  end

  # GET /events/:id
  def show
    @event = Event.find(params[:id])
  end

  # GET /events/new
  def new
    @event = Event.new
    event_seed = EventSeed.new
    event_seed.event_generators << EventGenerator.new
    @event.event_seeds << event_seed
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    if @event.save
      flash[:success] = "New event created"

      # TODO: Smelly? - it isn't clear here that @event.generate is creating event instances as well as returning dates
      # Should trigger ALL generators? Currently can only create one...
      dates = @event.event_seeds.first.event_generators.first.generate

      date_string = dates.map(&:to_s).join(", ") # TODO: Better way of doing this - in one step?
      flash[:success] += ". #{dates.count} instances created: #{date_string}"

      redirect_to @event
    else
      render :new
    end
  end

private

  def event_params
    params.require(:event).permit(
      :name,
      event_seeds_attributes:
        [ :url,
          event_generators_attributes: [ :frequency, :start_date ]
        ]
    )
  end

end