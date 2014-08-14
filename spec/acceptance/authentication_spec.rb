require 'rails_helper'

feature "Logged Out User tries to access a page:" do
  before { @event_instance = Fabricate.create(:event_instance_with_dependencies) }
  let(:event) { @event_instance.event_seed.event }
  {
    "event_instances" => "Event Instances",
  }.each do |path, text|
    scenario path do
      visit path
      expect(page).to have_content(text)
    end
  end

  # TODO - find a better way to do this
  {
    "new_event_date" => ->(id) { "/events/#{id}/dates/new" },
    "list_events"    => ->(id) { "/events" },
    "new_event"      => ->(id) { "/events/new" },
    "show_event"     => ->(id) { "/events/#{id}" },
  }.each do |name, path|
    scenario name do
      visit path.call(event.to_param)
      expect(page).to have_content('Sign in')
    end
  end
  # TODO: The above are just GET - Also prevent PUT etc
end