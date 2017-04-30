require 'rails_helper'

RSpec.feature 'Admin adds dates to an event:' do
  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario 'two non-repeating dates' do
    event = non_repeating_event

    visit '/events'

    click_link event.name

    Timecop.freeze(Date.new(2001, 1, 20)) do
      click_link 'Add date'
      fill_in 'event_instance[date]', with: '22/01/2001'
      click_button 'Done'

      click_link 'Add date'
      fill_in 'event_instance[date]', with: '23/01/2001'
      click_button 'Done'
    end

    expect(page).to have_content '22/01/2001'
    expect(page).to have_content '23/01/2001'
  end

  scenario 'an invalid date' do
    event = non_repeating_event

    visit '/events'
    click_link event.name

    Timecop.freeze(Date.new(2014, 12, 1)) do
      click_link 'Add date'
      fill_in 'event_instance[date]', with: '12/23/2014'
      click_button 'Done'

      expect(page).to have_content 'errors prevented this event from being saved'
      expect(page).to have_content 'is not a date'
      expect(page).to have_content "can't be blank" # Should be the date field

      fill_in 'event_instance[date]', with: '23/12/2014'
      click_button 'Done'
    end

    expect(page).to have_content '23/12/2014'
  end

  def non_repeating_event
    Fabricate.create(:event) do
      event_seeds(count: 1)
    end
  end
end
