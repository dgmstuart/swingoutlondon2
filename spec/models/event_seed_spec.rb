require 'rails_helper'

describe EventSeed, 'Associations', :type => :model do
  it { should belong_to(:event) }
  it { should have_many(:event_generators) }
  xit { should have_many(:event_instances) }
end

describe EventSeed, 'Validations', :type => :model do
  # it { should validate_presence_of(:url) } # Sufficiently covered by url validation?
  it "validates that url is a url" do
    expect( Fabricate.build(:event_seed, url: "foo") ).to_not be_valid
    expect( Fabricate.build(:event_seed, url: "http://foo.com") ).to be_valid
    expect( Fabricate.build(:event_seed, url: "https://foo.co.uk") ).to be_valid
  end
end