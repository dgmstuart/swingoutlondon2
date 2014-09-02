require 'rails_helper'

describe Venue, 'Associations', :type => :model do
  it { should have_many(:event_seeds) }
  it { should have_many(:event_instances) }
  it { should have_many(:dance_classes) }
end

describe Venue, 'Validations', :type => :model do

end

describe Venue, :type => :model do
  it_should_behave_like "sortable"
end