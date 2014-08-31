require 'capybara/rspec'

# This bit will be fairly fragile
def event_instance_group_on_event_page(date_string)
  find("li", text: date_string)
end
def event_instance_group_in_event_instances_list(date_string)
  find("li", text: date_string)
end