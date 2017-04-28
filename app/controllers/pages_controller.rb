class PagesController < ApplicationController
  layout 'public'

  def home
    @listing_dance_classes = ListingDanceClasses.new
    @listing_socials       = ListingSocials.new
  end
end
