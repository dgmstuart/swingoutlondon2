Fabricator(:event) do
  url "http://foo.com"
  frequency 0
  date { Date.today }
end
