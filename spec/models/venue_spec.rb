require 'rails_helper'

RSpec.describe Venue, 'Associations', :type => :model do
  it { should have_many(:event_seeds) }
  it { should have_many(:event_instances) }
  it { should have_many(:dance_classes) }
end

RSpec.describe Venue, 'Validations', :type => :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:postcode) }
  it { should validate_presence_of(:url) }

  it { should validate_uniqueness_of(:name) }
  it_should_behave_like "validates url"

end

RSpec.describe Venue, :type => :model do
  it_should_behave_like "sortable"
end