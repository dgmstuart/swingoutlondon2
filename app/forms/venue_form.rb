class VenueForm
  include ActiveModel::Model

  attr_writer :id
  attr_accessor :name
  attr_accessor :address
  attr_accessor :postcode
  attr_accessor :url
  attr_writer :create_venue

  def id
    Integer(@id) unless @id.empty?
  end

  def create_venue
    true unless @create_venue.nil?
  end
end
