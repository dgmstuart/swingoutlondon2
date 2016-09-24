class PagesController < ApplicationController
  def home
    @listing_dance_classes = ListingDanceClasses.new
  end
end
