class VenuesController < ApplicationController
  # GET /venues/new
  def new
    @venue = Venue.new
  end

  # POST /venues
  def create
    @venue = Venue.new(venue_params)

    if @venue.save
      flash[:success] = "New venue created"
      redirect_to @venue
    else
      render :new
    end
  end

private

  def venue_params
    params.require(:venue).permit(
      :name,
      :address,
      :postcode,
      :url
    )
  end

end