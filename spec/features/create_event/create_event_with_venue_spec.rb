require 'rails_helper'

RSpec.feature 'Admin adds an event', type: :feature do
  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario 'with a new venue', :js do
    when_i_create_an_event_with_a_new_venue
    then_the_event_should_be_displayed
    and_the_new_venue_should_be_displayed
    and_an_event_instance_should_be_displayed_in_the_event_instance_list
    and_the_new_venue_should_be_displayed_in_the_venues_list
  end

  scenario 'with missing venue data', :js do
    when_i_create_an_event_with_a_new_venue_with_missing_data
    then_missing_data_errors_should_be_displayed
  end

  scenario 'with invalid venue data', :js do
    when_i_create_an_event_with_a_new_venue_with_invalid_data
    then_invalid_venue_data_errors_should_be_displayed
  end

  # STEPS:
  ############################################################

  def when_i_create_an_event_with_a_new_venue
    visit '/events/new'
    within(new_event_form_id) do
      select_todays_date
      fill_event_fields_with_valid_data

      click_link 'New venue'

      @venue_name = Faker::App.name

      fill_in venue_field('name'),     with: @venue_name
      fill_in venue_field('address'),  with: Faker::Address.street_address
      fill_in venue_field('postcode'), with: Faker::Address.postcode
      fill_in venue_field('url'),      with: Faker::Internet.url

      click_button 'Create event'
    end
  end

  def and_the_new_venue_should_be_displayed
    expect(page).to have_content @venue_name
  end

  def and_the_new_venue_should_be_displayed_in_the_venues_list
    visit '/venues'
    expect(page).to have_content @venue_name
  end

  def when_i_create_an_event_with_a_new_venue_with_invalid_data
    Fabricate.create(:venue, name: 'non-unique name')
    visit '/events/new'
    within(new_event_form_id) do
      fill_event_fields_with_valid_data
      select_todays_date

      click_link 'New venue'

      fill_in venue_field('name'),     with: 'non-unique name'
      fill_in venue_field('address'),  with: 'bar' # Valid
      fill_in venue_field('postcode'), with: 'some nons!ense' # Valid until we check (!)
      fill_in venue_field('url'),      with: 'foo!bar.zx'

      click_button 'Create event'
    end
  end

  def then_invalid_venue_data_errors_should_be_displayed
    expect(page).to have_content('has already been taken')
      .and have_content('must be a valid URL')
  end

  def when_i_create_an_event_with_a_new_venue_with_missing_data
    visit '/events/new'
    within(new_event_form_id) do
      fill_event_fields_with_valid_data
      select_todays_date

      click_link 'New venue'

      click_button 'Create event'
    end
  end

  def then_missing_data_errors_should_be_displayed
    expect(page).to have_content('1 error prevented this event from being saved')
      .and have_content("can't be blank", count: 4)
  end
end
