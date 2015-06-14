Fabricator(:event_seed) do
  url { Faker::Internet.url }
  venue
  event
end

