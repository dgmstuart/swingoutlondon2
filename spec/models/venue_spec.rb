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

  # TODO: validate correctness of postcode
  it_should_behave_like "validates url"

  # Validating uniqueness is a little different because it touches the database:
  # http://matchers.shoulda.io/docs/v2.8.0/Shoulda/Matchers/ActiveRecord.html#validate_uniqueness_of-instance_method
  subject { Fabricate.build(:venue) }
  it { should validate_uniqueness_of(:name) }
end

RSpec.describe Venue, :type => :model do
  it_should_behave_like "sortable"
end
