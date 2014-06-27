require 'spec_helper'

describe "adding an event", :type => :feature do
  it "allows an event to be created with a url" do
    @event = Fabricate.build(:event)
    visit '/events/new'
    within(".new_event") do
      fill_in 'event[url]', :with => @event.url

      click_button 'Create event'
    end

    expect(page).to have_content "New event created"
  end
end