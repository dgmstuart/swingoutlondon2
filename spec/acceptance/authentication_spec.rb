require 'rails_helper'

feature "Logged Out User tries to access a page:" do
  let(:event) { Fabricate.create(:event) }
  {
    "event_instances" => "Event Instances",
  }.each do |path, text|
    scenario path do
      visit path
      expect(page).to have_content(text)
    end
  end

  # TODO - find a better way to do this
  {
    "new_event_date" => ->(id) { "/events/#{id}/dates/new" },
    "list_events"    => ->(id) { "/events" },
    "new_event"      => ->(id) { "/events/new" },
    "show_event"     => ->(id) { "/events/#{id}" },
    "list_venues"    => ->(id) { "/venues" },
  }.each do |name, path|
    scenario name do
      visit path.call(event.to_param)
      expect(page).to have_content('You need to sign in')
    end
  end
  # TODO: The above are just GET - Also prevent PUT etc
end

feature "Logged Out User logs in" do
  let(:user) { Fabricate.create(:user) }
  scenario "with valid details" do
    when_i_sign_in_with_valid_details
    then_i_should_be_logged_in
  end

  scenario "with an invalid password" do
    when_i_sign_in_with_an_invalid_password
    then_i_should_not_be_logged_in
  end

  def when_i_sign_in_with_valid_details
    sign_in_with(user.email, user.password)
  end

  def when_i_sign_in_with_an_invalid_password
    sign_in_with(user.email, "nonsense")
  end

  def when_i_sign_in_with_an_invalid_email_address
    sign_in_with("foo@bar.com", user.password)
  end

  def then_i_should_not_be_logged_in
    expect(page).to have_content('Log in')
  end

  def then_i_should_be_logged_in
    expect(page).to have_content("Logged in as #{user.email}")
    expect(page).to have_content('Log out')
  end

  def sign_in_with(email, password)
    visit "/users/sign_in"
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
  end
end

