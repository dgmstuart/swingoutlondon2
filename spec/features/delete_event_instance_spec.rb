require 'rails_helper'

RSpec.feature "Admin deletes an event instance", type: :feature do
  given(:event_instance) { Fabricate.create(:event_instance) }

  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario "from the event page" do
    given_an_event_instance
    when_i_delete_that_instance_from_the_events_page
    then_that_event_does_not_display_on_the_events_page
    and_that_event_does_not_display_in_the_event_instances_list
  end

  def given_an_event_instance
    event_instance
  end

  def when_i_delete_that_instance_from_the_events_page
    visit "/events"
    click_link event_instance.name
    within event_instance_group_on_event_page(event_instance.date.to_s(:casual)) do
      click_button "Bin"
    end
  end

  def then_that_event_does_not_display_on_the_events_page
    expect(page).to have_text "Event instance deleted: #{event_instance.name} on #{event_instance.date}"
    within ".event_instances" do
      expect(page).to_not have_text event_instance.date.to_s
    end
  end

  def and_that_event_does_not_display_in_the_event_instances_list
    visit "/event_instances"
    expect(page).to_not have_text event_instance.date.to_s
  end
end
