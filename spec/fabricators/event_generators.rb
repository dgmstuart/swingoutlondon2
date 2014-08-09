Fabricator(:event_generator) do
  frequency 0
  start_date { Date.today }
  event_seed
end