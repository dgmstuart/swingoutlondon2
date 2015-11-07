module ActiveSupport
  class Duration
    def from_today
      from_now(Time.zone.today)
    end
  end
end

module SchedulingSteps
  def given_an_existing_weekly_repeating_event
    start_date = @current_start_date || Faker::Date.backward
    generator = Fabricate.build(:event_period, frequency: 1, start_date: start_date, end_date: @current_end_date)
    generator.save(validate: false)
    @event = generator.event
    visit "events/#{@event.to_param}"
  end

  def given_some_future_scheduled_instances(instance_dates)
    event_seed = @event.event_seeds.last
    instance_dates.each do |date|
      Fabricate.create(:event_instance, date: date, event_seed: event_seed)
    end
  end

  def given_an_event_with_no_periods
    # TODO: we should be able to redesign this so that all we need is an event,
    #   not an event seed. Periods shouldn't be dependent on seeds (?)
    @event = Fabricate.create(:event_seed).event
    visit "events/#{@event.to_param}"
  end

  def when_i_schedule_an_ending
    click_link end_period_link

    fill_in end_date_field, with: @end_date
    click_button 'Submit' # TODO: use a better name!
  end

  def then_the_period_is_shown_as_ended
    expect(page).to have_text "Ended: #{I18n.l(@end_date)}"
    expect(page).to_not have_link(end_period_link)
  end

  def when_i_schedule_a_new_period
    click_link 'New period'
    fill_in start_date_field, with: @new_start_date
    select 'Weekly', from: frequency_select
    click_button 'Submit' # TODO: use a better name!
  end

  def then_a_new_period_is_shown_as_starting
    expect(page).to have_text "Started: #{@new_start_date}"
  end

  def and_the_previous_period_is_shown_as_ended
    expect(page).to have_text "Ended: #{I18n.l @new_start_date}"
  end

  def then_i_should_see_an_error(message)
    expect(page).to have_text message
  end

  def then_i_am_asked_if_i_want_to_delete_the_orphaned_instances(orphaned_dates)
    expect(page).to have_text "The following event instances now don't fall within any period:"
    expect(page).to have_text 'Would you like to delete them?'
    orphaned_dates.each do |date|
      expect(page).to have_text date
    end
    expect(page).to have_selector('input[type=checkbox]', count: 2)
  end

  def when_i_delete_an_orphaned_instance(orphaned_date)
    check(orphaned_date)
    click_button 'Delete'
  end

  def then_that_instance_does_not_display_on_the_event_page(deleted_instance_date:, remaining_instance_date:)
    expect(page).to have_text "Orphaned instances deleted: #{deleted_instance_date}"
    within '.event_instances' do
      expect(page).to_not have_text deleted_instance_date
      expect(page).to have_text remaining_instance_date
    end
  end

  def end_date_field
    'event_period[end_date]'
  end

  def start_date_field
    'event_period[start_date]'
  end

  def frequency_select
    'event_period[frequency]'
  end

  def end_period_link
    'End period'
  end
end
