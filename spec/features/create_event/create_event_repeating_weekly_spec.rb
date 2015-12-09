require 'rails_helper'

RSpec.feature "Admin adds an event", type: :feature do
  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario "which repeats weekly", js: true do
    Timecop.freeze(Date.new(2001, 1, 1)) do
      given_an_existing_venue
      when_i_create_a_weekly_repeating_event
      then_events_for_the_next_4_weeks_should_be_displayed
      and_events_for_the_next_4_weeks_should_be_displayed_on_the_event_page
    end
  end

  # STEPS:
  ############################################################

  def when_i_create_a_weekly_repeating_event
    visit '/events/new'

    @event_name       = Faker::Company.name
    @event_url        = Faker::Internet.url
    @event_start_date = Date.new(2001, 1, 3)
    @event_frequency  = 'Weekly'

    within(new_event_form_id) do
      fill_in_event_form
      select2 @existing_venue.name, from: "Venue"
      click_button 'Create event'
    end
  end

  def then_events_for_the_next_4_weeks_should_be_displayed
    expect(page).to have_content("New event created"
              ).and have_content("4 instances created"
              )
    display_4_events
  end

  def and_events_for_the_next_4_weeks_should_be_displayed_on_the_event_page
    visit "/events"
    click_link @event_name
    expect(page).to have_link("Wednesday 3rd January", href: @event_url
              ).and have_link("Wednesday 10th January", href: @event_url
              ).and have_link("Wednesday 17th January", href: @event_url
              ).and have_link("Wednesday 24th January", href: @event_url
              )
    display_4_events
  end

  def and_events_for_the_next_4_weeks_should_show_in_the_event_instance_list
    visit '/event_instances'
    expect(page).to have_content(@event_url, count: 4)
    display_4_events
  end

  # HELPERS:
  ############################################################

  def display_4_events
    expect(page)
      .to have_content("Wednesday 3rd January")
      .and have_content("Wednesday 10th January")
      .and have_content("Wednesday 17th January")
      .and have_content("Wednesday 24th January")
  end

end
