require 'rails_helper'

RSpec.feature 'Admin adds an event', type: :feature do
  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario 'which repeats weekly', js: true do
    Timecop.freeze(Date.new(2001, 1, 1)) do
      existing_venue = Fabricate(:venue)

      visit '/events/new'

      event_name = Faker::Company.name
      event_url = Faker::Internet.url
      event_start_date = Date.new(2001, 1, 3)

      within(new_event_form_id) do
        fill_in name_field,       with: event_name
        fill_in url_field,        with: event_url
        select2('Weekly', from: 'Frequency')
        select_date(event_start_date)

        select2 existing_venue.name, from: 'Venue'
        click_button 'Create event'
      end


      expect(page)
        .to have_content(event_name)

      within('.alert-box') do
        expect(page)
          .to have_content('New event created')
          .and have_content('4 instances created')
          .and have_content('03/01/2001')
          .and have_content('10/01/2001')
          .and have_content('17/01/2001')
          .and have_content('24/01/2001')
      end

      expect(page)
        .to have_content(event_name)
        .and have_link('03/01/2001', href: event_url)
        .and have_link('10/01/2001', href: event_url)
        .and have_link('17/01/2001', href: event_url)
        .and have_link('24/01/2001', href: event_url)

      visit '/event_instances'

      expect(page).to have_link(event_name, count: 4)
      expect(page)
        .to have_content('03/01/2001')
        .and have_content('10/01/2001')
        .and have_content('17/01/2001')
        .and have_content('24/01/2001')
    end
  end
end
