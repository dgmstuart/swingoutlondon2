require 'spec_helper'
require 'timecop'
require 'active_support/core_ext/time' # So we can use Time.zone.today
require 'app/facades/listing_dance_classes'

RSpec.describe ListingDanceClasses do
  class FakeDanceClassFinder
    def by_day
      []
    end
  end

  before do
    Time.zone = 'Europe/London'
    stub_const('DanceClassFinder', FakeDanceClassFinder)
  end

  describe '#days' do
    it 'has monday as the first day' do
      item = described_class.new.days.first
      expect(item.as_id).to eq 'monday'
      expect(item.title).to eq 'Monday'
    end

    it "includes monday's dance classes" do
      monday_dance_classes = double('monday dance classes')
      tuesday_dance_classes = double('tuesday dance classes')
      fake_dance_class_finder = instance_double('DanceClassFinder')
      allow(fake_dance_class_finder).to receive(:by_day).and_return(
        1 => monday_dance_classes,
        2 => tuesday_dance_classes
      )
      item = described_class.new(fake_dance_class_finder).days.first
      expect(item.classes).to eq monday_dance_classes
    end

    it 'has tuesday as the second day' do
      item = described_class.new.days[1]
      expect(item.as_id).to eq 'tuesday'
      expect(item.title).to eq 'Tuesday'
    end

    it "includes tuesday's dance classes" do
      monday_dance_classes = double('monday dance classes')
      tuesday_dance_classes = double('tuesday dance classes')
      fake_dance_class_finder = instance_double('DanceClassFinder')
      allow(fake_dance_class_finder).to receive(:by_day).and_return(
        1 => monday_dance_classes,
        2 => tuesday_dance_classes
      )
      item = described_class.new(fake_dance_class_finder).days[1]
      expect(item.classes).to eq tuesday_dance_classes
    end

    it 'has wednesday as the third day' do
      item = described_class.new.days[2]
      expect(item.as_id).to eq 'wednesday'
      expect(item.title).to eq 'Wednesday'
    end

    it "includes wednesday's dance classes" do
      monday_dance_classes = double('monday dance classes')
      wednesday_dance_classes = double('wednesday dance classes')
      fake_dance_class_finder = instance_double('DanceClassFinder')
      allow(fake_dance_class_finder).to receive(:by_day).and_return(
        1 => monday_dance_classes,
        3 => wednesday_dance_classes
      )
      item = described_class.new(fake_dance_class_finder).days[2]
      expect(item.classes).to eq wednesday_dance_classes
    end

    it 'has thursday as the 4th day' do
      item = described_class.new.days[3]
      expect(item.as_id).to eq 'thursday'
      expect(item.title).to eq 'Thursday'
    end

    it "includes thursday's dance classes" do
      monday_dance_classes = double('monday dance classes')
      thursday_dance_classes = double('thursday dance classes')
      fake_dance_class_finder = instance_double('DanceClassFinder')
      allow(fake_dance_class_finder).to receive(:by_day).and_return(
        1 => monday_dance_classes,
        4 => thursday_dance_classes
      )
      item = described_class.new(fake_dance_class_finder).days[3]
      expect(item.classes).to eq thursday_dance_classes
    end

    it 'has friday as the 5th day' do
      item = described_class.new.days[4]
      expect(item.as_id).to eq 'friday'
      expect(item.title).to eq 'Friday'
    end

    it "includes friday's dance classes" do
      monday_dance_classes = double('monday dance classes')
      friday_dance_classes = double('friday dance classes')
      fake_dance_class_finder = instance_double('DanceClassFinder')
      allow(fake_dance_class_finder).to receive(:by_day).and_return(
        1 => monday_dance_classes,
        5 => friday_dance_classes
      )
      item = described_class.new(fake_dance_class_finder).days[4]
      expect(item.classes).to eq friday_dance_classes
    end

    it 'has saturday as the 6th day' do
      item = described_class.new.days[5]
      expect(item.as_id).to eq 'saturday'
      expect(item.title).to eq 'Saturday'
    end

    it "includes saturday's dance classes" do
      monday_dance_classes = double('monday dance classes')
      saturday_dance_classes = double('saturday dance classes')
      fake_dance_class_finder = instance_double('DanceClassFinder')
      allow(fake_dance_class_finder).to receive(:by_day).and_return(
        1 => monday_dance_classes,
        6 => saturday_dance_classes
      )
      item = described_class.new(fake_dance_class_finder).days[5]
      expect(item.classes).to eq saturday_dance_classes
    end

    it 'has sunday as the last day' do
      item = described_class.new.days[6]
      expect(item.as_id).to eq 'sunday'
      expect(item.title).to eq 'Sunday'
    end

    it "includes sunday's dance classes" do
      monday_dance_classes = double('monday dance classes')
      sunday_dance_classes = double('sunday dance classes')
      fake_dance_class_finder = instance_double('DanceClassFinder')
      allow(fake_dance_class_finder).to receive(:by_day).and_return(
        1 => monday_dance_classes,
        0 => sunday_dance_classes
      )
      item = described_class.new(fake_dance_class_finder).days[6]
      expect(item.classes).to eq sunday_dance_classes
    end

    it 'exposes when the day is today' do
      black_monday = Date.new(1987, 10, 19)
      Timecop.freeze(black_monday) do
        item = described_class.new.days.first
        expect(item.today?).to eq true
      end
    end

    it 'exposes when the day is not today' do
      black_monday = Date.new(1987, 10, 19)
      Timecop.freeze(black_monday) do
        item = described_class.new.days[1]
        expect(item.today?).to eq false
      end
    end
  end
end
