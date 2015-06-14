Fabricator(:event_instance) do
  date { Faker::Date.forward }
  venue
  event_seed
end
