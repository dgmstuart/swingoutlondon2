require 'spec_helper'

describe "adding an event", type: :feature do
  it "allows an event to be created with a url" do
    @event = Fabricate.build(:event)
    visit '/events/new'
    within(".new_event") do
      fill_in 'event[url]', with: @event.url
      select 'Intermittent', from: "event[frequency]"
      fill_in 'event[date]', with: @event.date

      click_button 'Create event'
    end

    expect(page).to have_content "New event created"
    expect(page).to have_content @event.url
  end
end

describe "adding a weekly event", type: :feature do
  it "adds events for the next 4 weeks in the future" do
    # TODO: DRY this up
    @event = Fabricate.build(:event)
    visit '/events/new'
    within(".new_event") do
      fill_in 'event[url]', with: @event.url
      select 'Weekly', from: "event[frequency]"
      fill_in 'event[date]', with: Date.new(2001, 1, 3)

      click_button 'Create event'
    end
    expect(page).to have_content "New event created"
    expect(page).to have_content "4 instances created"
    expect(page).to have_content "2001-01-03"
    expect(page).to have_content "2001-01-10"
    expect(page).to have_content "2001-01-17"
    expect(page).to have_content "2001-01-24"

    visit '/events'
    expect(page).to have_content(@event.url, count: 4)
    expect(page).to have_content "2001-01-03"
    expect(page).to have_content "2001-01-10"
    expect(page).to have_content "2001-01-17"
    expect(page).to have_content "2001-01-24"
  end
end