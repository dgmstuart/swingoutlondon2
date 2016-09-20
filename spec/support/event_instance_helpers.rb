require 'capybara/rspec'

# This bit will be fairly fragile
def event_instance_group_on_event_page(date)
  find('li', text: I18n.l(date))
end

def event_instance_group_in_event_instances_list(date)
  find('li', text: I18n.l(date))
end
