require 'rails_helper'

RSpec.feature "Admin schedules a new period", type: :feature do
  include SchedulingSteps

  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario 'when there are no existing periods' do
    @new_start_date = Date.today
    given_an_event_with_no_periods
    when_i_schedule_a_new_period
    then_a_new_period_is_shown_as_starting
  end

  scenario 'when the latest period is not finished' do
    @new_start_date = Date.today
    given_an_existing_weekly_repeating_event
    when_i_schedule_a_new_period
    then_a_new_period_is_shown_as_starting
    and_the_previous_period_is_shown_as_ended
  end

  # scenario 'when the latest period is not finished' is covered by schedule_event_break_spec

  scenario 'when the latest period finished after the new start date' do
    @current_end_date = Faker::Date.forward
    @new_start_date = Date.today
    given_an_existing_weekly_repeating_event
    when_i_schedule_a_new_period
    then_i_should_see_an_error("can't be before the end date")
  end
end
