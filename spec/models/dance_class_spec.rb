require 'rails_helper'

describe DanceClass, 'Associations', :type => :model do
  it { should belong_to(:venue) }
end

describe DanceClass, 'Validations', :type => :model do
end

describe DanceClass, :type => :model do
  # it_should_behave_like "sortable"

  describe ".day_name" do
    {
      1 => "Monday",
      2 => "Tuesday",
      3 => "Wednesday",
      4 => "Thursday",
      5 => "Friday",
      6 => "Saturday",
      7 => "Sunday"
    }.each_pair do |day, day_name|
      context "when .day is #{day}" do
        subject{ Fabricate.build(:dance_class, day: day).day_name  }
        let(:day) { day }
        it { is_expected.to eq day_name }
      end
    end
  end
end