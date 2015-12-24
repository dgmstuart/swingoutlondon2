require 'rails_helper'

RSpec.feature "Admin adds dates to an event:" do
  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  let(:event) do
    Fabricate.create(:event) do
      event_seeds(count: 1)
    end
  end
  scenario "two non-repeating dates" do
    Timecop.freeze(Date.new(2001, 1, 20)) do
      given_an_event
      when_i_add_two_dates_to_the_event
      then_those_dates_should_display_on_the_events_page
    end
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

    click_link "Add date"
    fill_in "event_period[start_date]", with: "22/01/2001"
    click_button "Done"

    click_link "Add date"
    fill_in "event_period[start_date]", with: "23/01/2001"
    click_button "Done"
  end

  def then_those_dates_should_display_on_the_events_page
    expect(page).to have_content "2001-01-22"
    expect(page).to have_content "2001-01-23"
  end

  def when_i_add_an_invalid_date_to_the_event
    visit "/events"
    click_link event.name

    click_link "Add date"
    fill_in "event_period[start_date]", with: "12/23/2014"
    click_button "Done"
  end

  def then_errors_should_be_displayed
    expect(page).to have_content "errors prevented this event from being saved"
    expect(page).to have_content "is not a date"
    expect(page).to have_content "can't be blank" # Should be the date field
  end
end
