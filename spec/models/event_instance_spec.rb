require 'rails_helper'

describe EventInstance, 'Associations', :type => :model do
  it { should belong_to(:event) }
  xit { should belong_to(:event_generator) }
  xit { should belong_to(:event_seed) }
end

describe EventInstance, 'Validations', :type => :model do
  # it { should validate_presence_of(:date) } # Sufficiently covered by date validation?
  it "validates that date is a date"
end
