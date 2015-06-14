require 'rails_helper'

RSpec.feature "Admin cancels an event", type: :feature do

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
    test_instance = Fabricate.times(3, :event_instance)[1]

    @event_date = test_instance.date
    @event_name = test_instance.event.name
  end

  def when_i_mark_one_date_as_cancelled_on_the_event_page
    visit "/events"
    click_link @event_name

    within event_instance_group_on_event_page(@event_date.to_s) do
      click_button "Cancel"
    end
  end

  def then_that_date_should_be_displayed_as_cancelled
    within event_instance_group_on_event_page(@event_date) do
      expect(page).to have_content "Cancelled"
      expect(page).to_not have_button(/^Cancel$/)
    end
  end

  def and_that_date_should_be_displayed_as_cancelled_in_the_event_instance_list
    visit "/event_instances"
    expect(event_instance_group_in_event_instances_list(@event_date)).to have_content "Cancelled"
  end
end


RSpec.feature "Admin un-cancels an event", type: :feature do
  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario "from the event page" do
    given_an_existing_cancelled_event
    when_i_mark_the_cancelled_date_as_not_cancelled_on_the_event_page
    then_that_date_should_not_be_displayed_as_cancelled
    and_that_date_should_not_be_displayed_as_cancelled_in_the_event_instance_list
  end

  # TODO: Would it be better to go through the process of creating an event explicitly?
  def given_an_existing_cancelled_event
    test_instance = Fabricate.create(:event_instance, cancelled: true)

    @event_date = test_instance.date
    @event_name = test_instance.event.name
  end

  def when_i_mark_the_cancelled_date_as_not_cancelled_on_the_event_page
    visit "/events"
    click_link @event_name

    within event_instance_group_on_event_page(@event_date.to_s) do
      click_button "Cancelled"
    end
  end

  def then_that_date_should_not_be_displayed_as_cancelled
    within event_instance_group_on_event_page(@event_date) do
      expect(page).to_not have_content "Cancelled"
      expect(page).to have_button "Cancel"
    end
  end

  def and_that_date_should_not_be_displayed_as_cancelled_in_the_event_instance_list
    visit "/event_instances"
    expect(event_instance_group_in_event_instances_list(@event_date)).to_not have_content "Cancelled"
  end
end
