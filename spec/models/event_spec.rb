require 'rails_helper'

RSpec.describe Event, 'Associations', :type => :model do
  it { should have_many(:event_seeds) }
  it { should have_many(:event_periods) }
  it { should have_many(:event_instances) }
end

RSpec.describe Event, 'Validations', :type => :model do
  it { should validate_presence_of(:name) }
end

RSpec.describe Event, :type => :model do
  it_should_behave_like "sortable"
end
