Fabricator(:event_instance) do
  date { Date.today }
end

Fabricator(:event_instance_with_dependencies, from: :event_instance) do
  event_seed { Fabricate(:event_seed_with_event) }
end