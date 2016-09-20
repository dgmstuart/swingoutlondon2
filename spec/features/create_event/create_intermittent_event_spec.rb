require 'rails_helper'

RSpec.feature 'Admin adds an intermittent event', type: :feature do
  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario 'with valid data', js: true do
    given_an_existing_venue
    when_i_create_a_new_intermittent_event
    then_the_event_should_be_displayed
    and_an_event_instance_should_be_displayed_in_the_event_instance_list
  end

  scenario 'with missing data' do
    when_i_create_an_event_with_missing_data
    then_missing_data_errors_should_be_displayed
  end

  scenario 'with invalid data' do
    when_i_create_an_event_with_invalid_data
    then_invalid_event_data_errors_should_be_displayed
  end

  # STEPS:
  ############################################################

  def when_i_create_a_new_intermittent_event
    visit '/events/new'
    within(new_event_form_id) do
      fill_event_fields_with_valid_data
      select2 @existing_venue.name, from: 'Venue'

      click_button 'Create event'
    end
  end

  def when_i_create_an_event_with_invalid_data
    visit '/events/new'
    within(new_event_form_id) do
      fill_in url_field, with: 'foo'
      fill_in start_date_field, with: '3333/01/4/27'

      click_button 'Create event'
    end
  end

  def then_invalid_event_data_errors_should_be_displayed
    expect(page).to have_content('must be a valid URL' # Supposed to match on the Url field
                                ).and have_content("can't be more than one year in the future" # Supposed to match on the date field
                                                  )
  end

  def when_i_create_an_event_with_missing_data
    visit '/events/new'
    within(new_event_form_id) do
      click_button 'Create event'
    end
  end

  def then_missing_data_errors_should_be_displayed
    expect(page)
      .to have_content('5 errors prevented this event from being saved')
      .and have_content("can't be blank", count: 5)
  end
end
