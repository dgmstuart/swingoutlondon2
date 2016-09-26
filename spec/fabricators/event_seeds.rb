Fabricator(:event_seed) do
  name { Faker::Company.name } # Not ideal for generating swing event names, but close enough
  url { Faker::Internet.url }
  venue
  event
end
