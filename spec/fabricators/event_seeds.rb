Fabricator(:event_seed) do
  url "http://foo.com"
end

Fabricator(:event_seed_with_event, from: :event_seed) do
  event
end