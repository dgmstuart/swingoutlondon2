Fabricator(:venue) do
  name     { sequence { |n| "Venue number #{n}" } }
  address  "12 foo,\nLondon"
  postcode 'N1 4PQ'
  url      'http://www.foo.com'
end
