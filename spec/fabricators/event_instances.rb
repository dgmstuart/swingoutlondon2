Fabricator(:event_instance) do
  date { Date.today }
  venue
  event_seed
end