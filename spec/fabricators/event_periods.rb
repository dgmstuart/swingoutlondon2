Fabricator(:event_period) do
  frequency 0
  start_date { Time.zone.today }
  event_seed
end
