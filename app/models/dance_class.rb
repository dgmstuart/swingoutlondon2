class DanceClass < ActiveRecord::Base
  belongs_to :venue, inverse_of: :event_instances

  def day_name
    Date::DAYNAMES[day%7]
  end
end