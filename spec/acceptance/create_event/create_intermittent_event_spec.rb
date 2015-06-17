require 'rails_helper'

RSpec.feature "Admin adds an intermittent event", type: :feature do
  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario "with valid data" do
    given_an_existing_venue
    when_i_create_a_new_intermittent_event
    then_the_event_should_be_displayed
    and_an_event_instance_should_be_displayed_in_the_event_instance_list
  end

  scenario "with missing data" do
    when_i_create_an_event_with_missing_data
    then_missing_data_errors_should_be_displayed
  end

  scenario "with invalid data" do
    when_i_create_an_event_with_invalid_data
    then_invalid_event_data_errors_should_be_displayed
  end

  # STEPS:
  ############################################################

  def when_i_create_a_new_intermittent_event
    visit '/events/new'
    within("#new_event") do
      fill_event_fields_with_valid_data
      select @existing_venue.name, from: venue_select

      click_button 'Create event'
    end
  end

  def when_i_create_an_event_with_invalid_data
    visit '/events/new'
    within("#new_event") do
      fill_in url_field, with: "foo"
      fill_in start_date_field, with: "3333/01/4/27"

      click_button 'Create event'
    end
  end

  def then_invalid_event_data_errors_should_be_displayed
    expect(page).to have_content("must be a valid URL" # Supposed to match on the Url field
              ).and have_content("must be before" # Supposed to match on the date field
              )
  end


  def when_i_create_an_event_with_missing_data
    visit '/events/new'
    within("#new_event") do
      click_button 'Create event'
    end
  end

  def then_missing_data_errors_should_be_displayed
    missing_data_errors(4,1)
  end
end
