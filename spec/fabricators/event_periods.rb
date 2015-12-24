Fabricator(:event_period) do
  frequency 0
  start_date { Date.today }
  event_seed
end
