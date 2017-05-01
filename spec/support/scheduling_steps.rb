module SchedulingSteps
  def given_an_existing_weekly_repeating_event
    start_date = @current_start_date || Faker::Date.backward
    generator = Fabricate.build(:event_period, frequency: 1, start_date: start_date, end_date: @current_end_date)
    generator.save(validate: false)
    @event = generator.event
    visit "events/#{@event.to_param}"
  end

  def given_an_event_with_no_periods
    # TODO: we should be able to redesign this so that all we need is an event,
    #   not an event seed. Periods shouldn't be dependent on seeds (?)
    @event = Fabricate.create(:event_seed).event
    visit "events/#{@event.to_param}"
  end

  def when_i_schedule_a_new_period
    click_link 'New period'
    fill_in start_date_field, with: @new_start_date
    select 'Weekly', from: frequency_select
    click_button 'Submit' # TODO: use a better name!
  end

  def then_a_new_period_is_shown_as_starting
    expect(page).to have_text "Started: #{I18n.l @new_start_date}"
  end

  def and_the_previous_period_is_shown_as_ended
    expect(page).to have_text "Ended: #{I18n.l @new_start_date}"
  end

  def then_i_should_see_an_error(message)
    expect(page).to have_text message
  end

  def end_date_field
    'event_period_ending[end_date]'
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
