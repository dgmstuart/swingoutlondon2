require 'rails_helper'

RSpec.describe Event, 'Associations', type: :model do
  it { should have_many(:event_seeds) }
  it { should have_many(:event_periods) }
  it { should have_many(:event_instances) }
end

RSpec.describe Event, 'Validations', type: :model do
  it { should validate_presence_of(:name) }
end

RSpec.describe Event, type: :model do
  it_should_behave_like 'sortable'

  describe 'last_event_period' do
    it 'returns the single event period if there is only one' do
      event_seed = Fabricate.create(:event_seed)
      event_period = Fabricate.create(:event_period, event_seed: event_seed)
      event = Fabricate.create(:event, event_seeds: [event_seed])

      expect(event.last_event_period).to eq event_period
    end

    it 'returns the latest event period if there is more than one' do
      Timecop.freeze(Date.new(2001, 1, 1)) do
        event_seed = Fabricate.create(:event_seed)

        Fabricate.create(:event_period, start_date: Date.new(2001, 1, 1), event_seed: event_seed)
        newest_event_period = Fabricate.create(:event_period, start_date: Date.new(2001, 1, 3), event_seed: event_seed)
        Fabricate.create(:event_period, start_date: Date.new(2001, 1, 2), event_seed: event_seed)

        event = Fabricate.create(:event, event_seeds: [event_seed])

        expect(event.last_event_period).to eq newest_event_period
      end
    end
  end
end
