require 'capybara/rspec'

def then_the_event_should_be_displayed
  expect(page).to have_content("New event created"
            ).and have_content(@event_name
            ).and have_link(@event_start_date.to_s, href: @event_url
            )
end

def and_an_event_instance_should_be_displayed_in_the_event_instance_list
  visit '/event_instances'
  expect(page).to have_content(@event_start_date
            ).and have_link(@event_name
            ).and have_link("View Site", href: @event_url
            )
end
