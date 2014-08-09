Fabricator(:event) do
  name "My Event"
end

Fabricator(:event_with_seed, from: :event) do
  event_seeds(count: 1)
end
