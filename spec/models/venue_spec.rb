require 'rails_helper'

describe Venue, 'Associations', :type => :model do
  it { should have_many(:event_seeds) }
  it { should have_many(:event_instances) }
end

describe Venue, 'Validations', :type => :model do

end

describe Venue, :type => :model do

end