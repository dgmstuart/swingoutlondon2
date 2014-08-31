require 'rails_helper'

feature "Admin cancels an event", type: :feature do
  given(:event_instance) { Fabricate(:event_instance) }

  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario "from the event page" do
    given_an_existing_event
    when_i_mark_one_date_as_cancelled_on_the_event_page
    then_that_date_should_be_displayed_as_cancelled
    and_that_date_should_be_displayed_as_cancelled_in_the_event_instance_list
  end

  # TODO: Would it be better to go through the process of creating an event explicitly?
  def given_an_existing_event
    event_instance
  end

  def when_i_mark_one_date_as_cancelled_on_the_event_page
    visit "/events"
    click_link event_instance.event.name

    within event_instance_group_on_event_page(event_instance.date) do
      click_button "Cancel"
    end
  end

  # This bit will be fairly fragile
  def event_instance_group_on_event_page(date_string)
    find("p", text: date_string).parent()
  end
  def event_instance_group_in_event_instances_list(date_string)
    find("li", text: date_string)
  end

  def then_that_date_should_be_displayed_as_cancelled
    expect(event_instance_group_on_event_page(event_instance.date)).to have_content "Cancelled"
  end

  def and_that_date_should_be_displayed_as_cancelled_in_the_event_instance_list
    visit "/event_instances"
    expect(event_instance_group_in_event_instances_list(event_instance.date)).to have_content "Cancelled"
  end
end