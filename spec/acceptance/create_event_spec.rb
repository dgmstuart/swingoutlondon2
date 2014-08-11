require 'rails_helper'

def start_date_field
  "event[event_seeds_attributes][0][event_generators_attributes][0][start_date]"
end
def frequency_field
  "event[event_seeds_attributes][0][event_generators_attributes][0][frequency]"
end
def url_field
  "event[event_seeds_attributes][0][url]"
end


feature "Admin adds an event", type: :feature do
  let(:event) { Fabricate.build(:event) }
  let(:event_seed) { Fabricate.build(:event_seed) }
  let(:event_generator) { Fabricate.build(:event_generator) }

  scenario "with a url" do
    when_i_create_a_new_event_with_valid_data
    then_the_event_should_be_displayed
    and_an_event_instance_should_show_in_the_event_instance_list
  end

  scenario "with invalid data" do
    when_i_create_an_event_with_invalid_data
    then_errors_should_be_displayed
  end

  scenario "which repeats weekly" do
    Timecop.freeze(Date.new(2001, 1, 1)) do
      when_i_create_a_weekly_repeating_event
      then_events_for_the_next_4_weeks_should_be_displayed
      and_events_for_the_next_4_weeks_should_be_displayed_on_the_event_page
    end
  end

  # STEPS:

  def when_i_create_a_new_event_with_valid_data
    visit '/events/new'
    within("#new_event") do
      fill_in "event[name]", with: event.name
      fill_in url_field, with: event_seed.url
      select 'Intermittent', from: frequency_field
      fill_in start_date_field, with: event_generator.start_date

      click_button 'Create event'
    end
  end

  def then_the_event_should_be_displayed
    expect(page).to have_content "New event created"
    expect(page).to have_content event_seed.url
  end

  def and_an_event_instance_should_show_in_the_event_instance_list
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
      select 'Weekly', from: frequency_field
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
end