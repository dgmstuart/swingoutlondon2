require 'rails_helper'

RSpec.feature 'Admin schedules a break', type: :feature do
  include SchedulingSteps

  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario 'in a weekly event' do
    @current_start_date = Time.zone.today - 60
    @end_date = Time.zone.today + 7
    @new_start_date = Time.zone.today + 56
    given_an_existing_weekly_repeating_event
    when_i_schedule_an_ending
    then_the_period_is_shown_as_ended
    when_i_schedule_a_new_period
    then_a_new_period_is_shown_as_starting
  end

  scenario 'ending before it starts' do
    Timecop.freeze(Date.new(2016, 9, 6)) do
      @current_start_date = Time.zone.today + 10
      @end_date = Time.zone.today + 2
      given_an_existing_weekly_repeating_event
      when_i_schedule_an_ending
      expect(page).to have_content "can't be before start date (16/09/2016)"
    end
  end

  # TODO: should this be grouped with other 'handling existing instances'
  # specs instead of scheduling specs?
  scenario 'in a weekly event with instances' do
    Timecop.freeze(Date.new(1970, 1, 13)) do
      before_date     = Time.zone.today
      @end_date       = 3.days.from_now
      orphaned_date_1 = 1.week.from_now
      orphaned_date_2 = 2.weeks.from_now
      @new_start_date = 2.weeks.from_now + 3.days

      instance_dates = [
        before_date,
        orphaned_date_1,
        orphaned_date_2,
      ]
      orphaned_dates = [
        '20/01/1970',
        '27/01/1970',
      ]

      given_an_existing_weekly_repeating_event
      given_some_future_scheduled_instances(instance_dates)
      when_i_schedule_an_ending
      then_i_am_asked_if_i_want_to_delete_the_orphaned_instances(orphaned_dates)
      when_i_delete_an_orphaned_instance('20/01/1970')
      then_that_instance_does_not_display_on_the_event_page(deleted_instance_date: '20/01/1970', remaining_instance_date: '27/01/1970')
    end
  end

  xscenario 'in a weekly event with instances within a new period' do
    Timecop.freeze(Date.new(1970, 1, 13)) do
      before_date     = Time.zone.today
      @end_date       = 3.days.from_now
      @new_start_date = 10.days.from_now
      after_date      = 20.days.from_now

      instance_dates = [
        before_date,
        after_date,
      ]
      overlapping_dates = [
        after_date,
      ]

      given_an_existing_weekly_repeating_event
      given_some_future_scheduled_instances(instance_dates)
      when_i_schedule_a_new_period
      then_i_am_asked_if_i_want_to_associate_the_overlapping_instances(overlapping_dates)
    end
  end
end
