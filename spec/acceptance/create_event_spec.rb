require 'rails_helper'

feature "Admin adds an event", type: :feature do
  let(:event_generator) { Fabricate.build(:event_generator) }
  let(:event_seed) { event_generator.event_seed }
  let(:event) { event_seed.event }

  let(:venue) { Fabricate.build(:venue) }
  let(:existing_venue) { Fabricate.create(:venue, name: "Other thing") }

  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario "with a url" do
    given_an_existing_venue
    when_i_create_a_new_event_with_valid_data
    then_the_event_should_be_displayed
    and_an_event_instance_should_be_displayed_in_the_event_instance_list
  end

  scenario "with invalid data" do
    when_i_create_an_event_with_invalid_data
    then_errors_should_be_displayed
  end

  scenario "which repeats weekly" do
    Timecop.freeze(Date.new(2001, 1, 1)) do
      given_an_existing_venue
      when_i_create_a_weekly_repeating_event
      then_events_for_the_next_4_weeks_should_be_displayed
      and_events_for_the_next_4_weeks_should_be_displayed_on_the_event_page
    end
  end

  scenario "with a new venue", :js do
    when_i_create_an_event_with_a_new_venue
    then_the_venue_should_be_displayed_with_the_event
    and_an_event_instance_should_be_displayed_in_the_event_instance_list
    and_the_venue_should_be_displayed_in_the_venues_list
  end

  # STEPS:

  def given_an_existing_venue
    existing_venue
  end

  def when_i_create_a_new_event_with_valid_data
    visit '/events/new'
    within("#new_event") do
      fill_event_fields_with_valid_data
      select existing_venue.name, from: venue_select

      click_button 'Create event'
    end
  end

  def fill_event_fields_with_valid_data
    # TODO: Does this actually respect the "within" block?
    fill_in "event[name]", with: event.name
    fill_in url_field, with: event_seed.url
    select 'Intermittent', from: frequency_select
    fill_in start_date_field, with: event_generator.start_date
  end

  def then_the_event_should_be_displayed
    expect(page).to have_content "New event created"
    expect(page).to have_content event_seed.url
  end

  def and_an_event_instance_should_be_displayed_in_the_event_instance_list
    visit '/event_instances'
    expect(page).to have_content event_generator.start_date
    expect(page).to have_content event_seed.url
  end

  def when_i_create_an_event_with_invalid_data
    visit '/events/new'
    within("#new_event") do
      fill_in url_field, with: "foo"
      fill_in start_date_field, with: "3333/01/4/27"

      click_button 'Create event'
    end
  end

  def then_errors_should_be_displayed
    expect(page).to have_content "errors prevented this event from being saved"
    expect(page).to have_content "can't be blank", count: 2 # Supposed to match on the Frequency and name fields
    expect(page).to have_content "must be a valid URL" # Supposed to match on the Url field
    expect(page).to have_content "must be before" # Supposed to match on the date field
  end

  def when_i_create_a_weekly_repeating_event
    visit '/events/new'
    within("#new_event") do
      fill_in "event[name]", with: event.name
      fill_in url_field, with: event_seed.url
      select existing_venue.name, from: venue_select
      select 'Weekly', from: frequency_select
      fill_in start_date_field, with: Date.new(2001, 1, 3)

      click_button 'Create event'
    end
  end

  def then_events_for_the_next_4_weeks_should_be_displayed
    expect(page).to have_content "New event created"
    expect(page).to have_content "4 instances created"
    display_4_events
  end

  def and_events_for_the_next_4_weeks_should_be_displayed_on_the_event_page
    visit "/events"
    click_link event.name
    expect(page).to have_content(event_seed.url, count: 4)
    display_4_events
  end

  def and_events_for_the_next_4_weeks_should_show_in_the_event_instance_list
    visit '/event_instances'
    expect(page).to have_content(event_seed.url, count: 4)
    display_4_events
  end

  def display_4_events
    expect(page).to have_content "2001-01-03"
    expect(page).to have_content "2001-01-10"
    expect(page).to have_content "2001-01-17"
    expect(page).to have_content "2001-01-24"
  end

  def when_i_create_an_event_with_a_new_venue
    visit '/events/new'
    within("#new_event") do
      fill_event_fields_with_valid_data
      select_todays_date

      click_link 'New venue'

      fill_in venue_field("name"),     with: venue.name
      fill_in venue_field("address"),  with: venue.address
      fill_in venue_field("postcode"), with: venue.postcode
      fill_in venue_field("url"),      with: venue.url

      click_button 'Create event'
    end
  end

  # Tests using selenium can't just fill in a date because the datepicker makes the field readonly
  def select_todays_date
    # HACK? TODO: would be nicer to activate the datepicker directly, but
    # => Capybara's click methods seem to only work on links and buttons
    page.execute_script("$('[name=\"#{start_date_field}\"]').val('#{Date.today.to_s}')")
  end

  def then_the_venue_should_be_displayed_with_the_event
    then_the_event_should_be_displayed
    expect(page).to have_content venue.name
  end

  def and_the_venue_should_be_displayed_in_the_venues_list
    visit "/venues"
    expect(page).to have_content venue.name
  end

  # FIELDS

  def start_date_field
    event_generator_field "start_date"
  end
  def frequency_select
    event_generator_field "frequency"
  end
  def url_field
    event_seed_field "url"
  end
  def venue_select
    event_seed_field "venue_id"
  end

  def event_seed_field(field)
    "event[event_seeds_attributes][0][#{field}]"
  end
  def event_generator_field(field)
    "event[event_seeds_attributes][0][event_generators_attributes][0][#{field}]"
  end
  def venue_field(field)
    "event[event_seeds_attributes][0][venue_attributes][#{field}]"
  end
end