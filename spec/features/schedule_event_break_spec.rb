require 'rails_helper'

RSpec.feature "Admin schedules a break", type: :feature do
  include SchedulingSteps

  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario 'in a weekly event' do
    @current_start_date = Date.today - 60
    @end_date = Date.today + 7
    @new_start_date = Date.today + 56
    given_an_existing_weekly_repeating_event
    when_i_schedule_an_ending
    then_the_period_is_shown_as_ended
    when_i_schedule_a_new_period
    then_a_new_period_is_shown_as_starting
  end

  scenario 'ending before it starts' do
    Timecop.freeze(Date.new(2016, 9, 6)) do
      @current_start_date = Date.today + 10
      @end_date = Date.today + 2
      given_an_existing_weekly_repeating_event
      when_i_schedule_an_ending
      expect(page).to have_content "can't be before start date (16/09/2016)"
    end
  end
end
