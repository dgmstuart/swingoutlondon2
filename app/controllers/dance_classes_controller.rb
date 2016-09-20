class DanceClassesController < ApplicationController
  before_action :authenticate_user!

  # GET /dance_classes
  def index
    @dance_classes = DanceClass.all
  end

  # GET /dance_classes/:id
  def show
    @dance_class = DanceClass.find(params[:id])
  end

  # GET /dance_classes/new
  def new
    @dance_class = DanceClass.new

    setup_venues
  end

  # POST /dance_classes
  def create
    @dance_class = DanceClass.new(dance_class_params)

    # if @dance_class.save
    @dance_class.save
    flash[:success] = 'New dance class created'
    redirect_to @dance_class
    # else
    #   setup_venues
    #   render :new
    # end
  end

  private

  def dance_class_params
    params.require(:dance_class).permit(:day, :venue_id)
  end
end
