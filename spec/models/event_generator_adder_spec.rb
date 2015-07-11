require 'rails_helper'
# TODO: should be able to just use spec_helper?
# But then EventGeneratorAdder doesn't get loaded. Are we supposed to just load it manually?

RSpec.describe EventGeneratorAdder, "Validations" do
  # it { should validate_presence_of(:previous_generator) }

  let(:date) { Faker::Date.forward }
  subject(:adder) {
    EventGeneratorAdder.new(@new_generator, @previous_generator)
  }
  context "when the previous generator has no end date" do
    context "and new start date is after the previous generator's start date" do
      before do
        mock_previous_generator(start_date: date)
        mock_new_generator(start_date: date + 1)
      end
      it { is_expected.to be_valid }
    end

    context "and new start date is before the previous generator's start date" do
      before do
        mock_previous_generator(start_date: date)
        mock_new_generator(start_date: date - 1)
      end
      it { is_expected.to be_invalid }
    end
  end

  context "when the new start date is before the previous generator's end date" do
    before do
      mock_previous_generator(end_date: date)
      mock_new_generator(start_date: date - 1)
    end
    it { is_expected.to be_invalid }
  end

  context "when the new start date is after the previous generator's end date" do
    before do
      mock_previous_generator(end_date: date)
      mock_new_generator(start_date: date + 1)
    end
    it { is_expected.to be_valid }
  end

  def mock_new_generator(start_date:)
    @new_generator = instance_double(EventGenerator)
    allow(@new_generator).to receive(:start_date).and_return(start_date)
    allow(@new_generator).to receive(:errors).and_return(ActiveModel::Errors.new(@new_generator))
  end

  def mock_previous_generator(start_date: nil, end_date: nil)
    # Set a valid start date if it's nil
    start_date ||= if end_date
      end_date - rand(52).weeks
    else
      Faker::Date.backward
    end

    @previous_generator = instance_double(EventGenerator)
    allow(@previous_generator).to receive(:start_date).and_return(start_date)
    allow(@previous_generator).to receive(:end_date).and_return(end_date)
  end
end

RSpec.describe EventGeneratorAdder do
  describe "#save" do
    it "saves the delegate object" do
      mock_new_generator
      mock_previous_generator

      EventGeneratorAdder.new(@new_generator, @previous_generator).add
      expect(@new_generator).to have_received(:save)
    end

    it "sets the end date of the previous generator to the start date of the new generator" do
      start_date = Faker::Date.forward
      mock_new_generator(start_date: start_date)
      mock_previous_generator

      EventGeneratorAdder.new(@new_generator, @previous_generator).add
      expect(@previous_generator).to have_received(:update_attributes!).with(end_date: start_date)
    end

    describe "return value" do
      subject { EventGeneratorAdder.new(@new_generator, @previous_generator).add }
      before { mock_previous_generator }
      context "if the new generator was valid" do
        before { mock_new_generator(valid: true) }
        it { is_expected.to eq true }
      end
      context "if the new generator was invalid" do
        before { mock_new_generator(valid: false) }
        it { is_expected.to eq false }
      end
    end


    def mock_new_generator(start_date: Faker::Date.forward, valid: true)
      @new_generator = instance_double(EventGenerator)
      allow(@new_generator).to receive(:valid?).and_return(valid)
      allow(@new_generator).to receive(:save)
      allow(@new_generator).to receive(:start_date).and_return(start_date)
      allow(@new_generator).to receive(:errors).and_return(ActiveModel::Errors.new(@new_generator))
    end

    def mock_previous_generator
      @previous_generator = instance_double(EventGenerator)
      allow(@previous_generator).to receive(:update_attributes!)
      allow(@previous_generator).to receive(:end_date)
      allow(@previous_generator).to receive(:start_date)
    end
  end
end

