require 'rails_helper'
require 'support/select2_helper.rb'
include Select2Helper

def fill_event_fields_with_valid_data
  @event_name       = Faker::Company.name
  @event_url        = Faker::Internet.url
  @event_frequency  = 'Intermittent'
  @event_start_date = Faker::Date.forward

  fill_in_event_form
end

def fill_in_event_form
  fill_in name_field,       with: @event_name       unless @event_name.nil?
  fill_in url_field,        with: @event_url        unless @event_url.nil?
  select2(@event_frequency, from: 'Frequency')      unless @event_frequency.nil?
  select_date(@event_start_date)                    unless @event_start_date.nil?
end

def select_todays_date
  @event_start_date = Time.zone.today
end

# Tests using selenium can't just fill in a date because the datepicker makes the field readonly
# TODO: Make this into a helper
def select_date(date_string)
  # HACK? TODO: would be nicer to activate the datepicker directly, but
  # Capybara's click methods seem to only work on links and buttons
  page.execute_script("$('[name=\"#{start_date_field}\"]').val('#{date_string}')")
end

# IDs
#####
def new_event_form_id
  '#new_event_form'
end

# FIELDS
############################################################

def name_field
  'event_form[name]'
end

def start_date_field
  'event_form[start_date]'
end

def frequency_select
  'event_form[frequency]'
end

def url_field
  'event_form[url]'
end

def venue_select
  'event_form[venue_id]'
end

def venue_field(field)
  "event_form[venue][#{field}]"
end
