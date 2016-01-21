require 'spec_helper'
require 'timecop'
require 'app/services/weekly_next_date_calculator'

RSpec.describe WeeklyNextDateCalculator do
  describe "#next_date" do
    subject(:next_date) { calculator.next_date(start_date) }
    let(:calculator) { described_class.new }

    let(:today) { Date.new(2001, 1, 23) }
    before { Timecop.freeze(today) }
    after { Timecop.return }

    context "and the start_date is today" do
      let(:start_date) { today }
      it { is_expected.to eq today }
    end
    context 'and the start_date is in the future' do
      let(:start_date) { today + 10 }
      it { is_expected.to eq start_date }
    end
    context 'and the start_date is one week ago today' do
      let(:start_date) { today - 7 }
      it { is_expected.to eq today }
    end
    context 'and the start_date is one week and one day ago' do
      let(:start_date) { today - 8 }
      let(:six_days_in_the_future) { today + 6 }
      it { is_expected.to eq six_days_in_the_future }
    end
    context 'and the start_date is one week less one day ago' do
      let(:start_date) { today - 6 }
      let(:tomorrow) { today + 1 }
      it { is_expected.to eq tomorrow }
    end
  end
end
