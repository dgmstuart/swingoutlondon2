require 'rails_helper'

feature "Logged Out User tries to access a page:" do
  before { Fabricate.create(:event, id: 1) }
  before { Fabricate.create(:event_instance, event_seed: Fabricate.build(:event_seed)) }
  [
    "event_instances"
  ].each do |page|
    scenario page do
      visit page
      raise "NOT IMPLEMENTED"
    end
  end

  [
    "/events/1/dates/new",
    "/events",
    "/events/new",
    "/events/1",
  ].each do |page|
    scenario page do
      visit page
      raise "NOT IMPLEMENTED"
    end
  end
  # TODO: The above are just GET - Also prevent PUT etc
end