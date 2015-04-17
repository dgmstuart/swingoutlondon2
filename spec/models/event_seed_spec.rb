require 'rails_helper'

RSpec.describe EventSeed, 'Associations', :type => :model do
  it { should belong_to(:event) }
  it { should have_many(:event_generators) }
  it { should have_many(:event_instances) }
  it { should belong_to(:venue) }
end

RSpec.describe EventSeed, 'Validations', :type => :model do
  it { should validate_presence_of(:url) }
  it { should validate_presence_of :venue }
  it_should_behave_like "validates url"
end