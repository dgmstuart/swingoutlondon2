require 'rails_helper'

feature "Admin adds dates to an event:" do
  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end
  let(:event) { Fabricate.create(:event_with_seed) }
  scenario "two non-repeating dates" do
    given_an_event
    when_i_add_two_dates_to_the_event
    then_those_dates_should_display_on_the_events_page
  end

  scenario "an invalid date" do
    given_an_event
    when_i_add_an_invalid_date_to_the_event
    then_errors_should_be_displayed
  end

  def given_an_event
    event
  end

  def when_i_add_two_dates_to_the_event
    visit "/events"
    click_link event.name

    click_link "add date"
    fill_in "event_generator[start_date]", with: "23/12/2014"
    click_button "done"

    click_link "add date"
    fill_in "event_generator[start_date]", with: "24/12/2014"
    click_button "done"
  end

  def then_those_dates_should_display_on_the_events_page
    expect(page).to have_content "2014-12-23"
    expect(page).to have_content "2014-12-24"
  end

  def when_i_add_an_invalid_date_to_the_event
    visit "/events"
    click_link event.name

    click_link "add date"
    fill_in "event_generator[start_date]", with: "12/23/2014"
    click_button "done"
  end

  def then_errors_should_be_displayed
    expect(page).to have_content "errors prevented this event from being saved"
    expect(page).to have_content "is not a date"
    expect(page).to have_content "can't be blank" # Should be the date field
  end
end