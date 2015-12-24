require 'rails_helper'
# TODO: should be able to just use spec_helper?
# But then EventPeriodAdder doesn't get loaded. Are we supposed to just load it manually?

RSpec.describe EventPeriodAdder, "Validations" do
  # it { should validate_presence_of(:previous_period) }

  let(:date) { Faker::Date.forward }
  subject(:adder) {
    EventPeriodAdder.new(@new_period, @previous_period)
  }
  context "when the previous generator has no end date" do
    context "and new start date is after the previous generator's start date" do
      before do
        mock_previous_period(start_date: date)
        mock_new_period(start_date: date + 1)
      end
      it { is_expected.to be_valid }
    end

    context "and new start date is before the previous generator's start date" do
      before do
        mock_previous_period(start_date: date)
        mock_new_period(start_date: date - 1)
      end
      it { is_expected.to be_invalid }
    end
  end

  context "when the new start date is before the previous generator's end date" do
    before do
      mock_previous_period(end_date: date)
      mock_new_period(start_date: date - 1)
    end
    it { is_expected.to be_invalid }
  end

  context "when the new start date is after the previous generator's end date" do
    before do
      mock_previous_period(end_date: date)
      mock_new_period(start_date: date + 1)
    end
    it { is_expected.to be_valid }
  end

  def mock_new_period(start_date:)
    @new_period = instance_double(EventPeriod)
    allow(@new_period).to receive(:start_date).and_return(start_date)
    allow(@new_period).to receive(:errors).and_return(ActiveModel::Errors.new(@new_period))
  end

  def mock_previous_period(start_date: nil, end_date: nil)
    # Set a valid start date if it's nil
    start_date ||= if end_date
      end_date - rand(52).weeks
    else
      Faker::Date.backward
    end

    @previous_period = instance_double(EventPeriod)
    allow(@previous_period).to receive(:start_date).and_return(start_date)
    allow(@previous_period).to receive(:end_date).and_return(end_date)
  end
end

RSpec.describe EventPeriodAdder do
  describe "#save" do
    it "saves the delegate object" do
      mock_new_period
      mock_previous_period

      EventPeriodAdder.new(@new_period, @previous_period).add
      expect(@new_period).to have_received(:save)
    end

    it "sets the end date of the previous generator to the start date of the new generator" do
      start_date = Faker::Date.forward
      mock_new_period(start_date: start_date)
      mock_previous_period

      EventPeriodAdder.new(@new_period, @previous_period).add
      expect(@previous_period).to have_received(:update_attributes!).with(end_date: start_date)
    end

    describe "return value" do
      subject { EventPeriodAdder.new(@new_period, @previous_period).add }
      before { mock_previous_period }
      context "if the new generator was valid" do
        before { mock_new_period(valid: true) }
        it { is_expected.to eq true }
      end
      context "if the new generator was invalid" do
        before { mock_new_period(valid: false) }
        it { is_expected.to eq false }
      end
    end


    def mock_new_period(start_date: Faker::Date.forward, valid: true)
      @new_period = instance_double(EventPeriod)
      allow(@new_period).to receive(:valid?).and_return(valid)
      allow(@new_period).to receive(:save)
      allow(@new_period).to receive(:start_date).and_return(start_date)
      allow(@new_period).to receive(:errors).and_return(ActiveModel::Errors.new(@new_period))
    end

    def mock_previous_period
      @previous_period = instance_double(EventPeriod)
      allow(@previous_period).to receive(:update_attributes!)
      allow(@previous_period).to receive(:end_date)
      allow(@previous_period).to receive(:start_date)
    end
  end
end

