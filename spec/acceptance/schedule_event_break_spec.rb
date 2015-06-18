require 'rails_helper'

RSpec.feature "Admin schedules a break", type: :feature do

  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  fscenario 'in a weekly event' do
    given_an_existing_weekly_repeating_event
    when_i_schedule_a_break
    then_i_can_see_the_dates_of_the_break
  end

  def given_an_existing_weekly_repeating_event
    generator = Fabricate.build(:event_generator, frequency: 1, start_date: Faker::Date.backward)
    generator.save(validate: false)
    @event = generator.event
  end

  def when_i_schedule_a_break
    visit "events/#{@event.to_param}"

    click_link 'End period'
    fill_in end_date_field,     with: Date.today + 7
    click_button 'Submit' # TODO: use a better name!

    click_link 'New period'
    fill_in "start_date_field",   with: Date.today + 56
    click_button 'Submit' # TODO: use a better name!
  end


  def end_date_field
    "event_generator[end_date]"
  end
end
