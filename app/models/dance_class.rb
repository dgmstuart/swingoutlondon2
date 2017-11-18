class DanceClass < ApplicationRecord
  belongs_to :venue, inverse_of: :event_instances

  # Order with Monday at the beginning. For some reason `day - 1` doesn't work
  default_scope { order('(day + 6) % 7') }

  def day_name
    Date::DAYNAMES[day % 7]
  end
end
