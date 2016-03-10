Fabricator(:event_instance) do
  date { Faker::Date.forward(364) }
  venue
  event_seed
end
