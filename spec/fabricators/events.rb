Fabricator(:event) do
  name { Faker::Company.name } # Not ideal for generating swing event names, but close enough
end
