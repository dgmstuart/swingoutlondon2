require 'rails_helper'

describe Event, 'Associations', :type => :model do
  it { should have_many(:event_seeds) }
  it { should have_many(:event_generators) }
  it { should have_many(:event_instances) }
end

describe Event, 'Validations', :type => :model do
  it { should validate_presence_of(:name) }
end

describe Event, :type => :model do

end