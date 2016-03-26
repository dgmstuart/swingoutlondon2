require 'spec_helper'
require 'active_model'
require 'app/validators/url_validator'
require 'app/forms/event_form'

# Date validation:
require 'active_support/core_ext/hash/reverse_merge' # Used by date_validator
require 'active_support/core_ext/integer/time' # Used by date_validator
require 'date_validator'
require 'timecop'

RSpec.describe EventForm, type: :model do
  describe ".name" do
    it "returns the value of the 'name' attribute" do
      name = double
      expect(EventForm.new(name: name).name).to eq name
    end
  end

  describe ".url" do
    it "returns the value of the 'url' attribute" do
      url = double
      expect(EventForm.new(url: url).url).to eq url
    end
  end

  describe ".frequency" do
    it "returns the value of the 'frequency' attribute" do
      frequency = double
      expect(EventForm.new(frequency: frequency).frequency).to eq frequency
    end
  end

  describe ".start_date" do
    it "returns a date based on the 'start_date' attribute" do
      expect(EventForm.new(start_date: "13 March, 2016").start_date).to eq Date.new(2016, 03, 13)
    end

    it "returns nil if the start date couldn't be parsed" do
      expect(EventForm.new(start_date: "130th jubevember, 20frumpteen").start_date).to eq nil
    end
  end

  # describe ".venue" do
  #   it "returns something" do
  #     # TODO: Better spec!
  #     expect(EventForm.new.venue).to_not be_nil
  #   end
  # end

  describe ".venue_id" do
    it "returns the value of the 'venue_id' attribute as an integer" do
      expect(EventForm.new(venue_id: "123").venue_id).to eq 123
    end

    it "returns nil if 'venue_id' is blank" do
      expect(EventForm.new(venue_id: "").venue_id).to eq nil
    end

    it "returns the venue's ID id a venue is present and create_venue is true" do
      params = { venue: instance_double("Venue", id: 456), create_venue: true }
      expect(EventForm.new(params).venue_id)
        .to eq 456
    end
  end

  describe "Validations:" do
    shared_examples_for "validates presence of" do |attribute|
      it "validates presence of #{attribute.to_s}" do
        form = EventForm.new
        form.valid?
        expect(form.errors.messages).to include(attribute => ["can't be blank"])
      end
    end

    it_behaves_like "validates presence of", :name
    it_behaves_like "validates presence of", :url
    it_behaves_like "validates presence of", :frequency
    it_behaves_like "validates presence of", :start_date

    it "is invalid if the url is not valid" do
      form = EventForm.new(url: "nonsense.qux")
      form.valid?
      expect(form.errors.messages).to include(:url => ["must be a valid URL"])
    end

    it "validates that start_date isn't too obviously old" do
      Timecop.freeze(Date.new(2016,01,01)) do
        form = EventForm.new(start_date: "13 April 2015")
        form.valid?
        expect(form.errors.messages).to include(:start_date => ["can't be more than 6 months in the past"])
      end
    end

    it "validates that start_date isn't clearly too far in the future" do
      Timecop.freeze(Date.new(2016,01,01)) do
        form = EventForm.new(start_date: "13 April 2017")
        form.valid?
        expect(form.errors.messages).to include(:start_date => ["can't be more than one year in the future"])
      end
    end

    context "if a new venue isn't being created" do
      it "is valid if there is a venue_id" do
        form = EventForm.new(venue_id: "23")
        form.valid?
        expect(form.errors.messages.keys).to_not include(:venue_id)
        expect(form.errors.messages.keys).to_not include(:venue)
      end

      it "is invalid if there is no venue_id and no venue details" do
        form = EventForm.new
        form.valid?
        expect(form.errors.messages).to include(:venue_id => ["can't be blank"])
      end
    end

    context "if a new venue IS being created" do
      it "is invalid if the venue details are invalid" do
        form = EventForm.new(venue: double(id: 17, valid?: false), create_venue: true)
        form.valid?
        expect(form.errors.messages).to include(:venue => ["is invalid"])
      end

      it "is invalid if there is a venue_id but no venue details" do
        form = EventForm.new(venue_id: "14", create_venue: true)
        form.valid?
        expect(form.errors.messages).to include(:venue => ["is invalid"])
      end

      it "is valid if there is a valid venue" do
        form = EventForm.new(venue: double(id: 17, valid?: true), create_venue: true)
        form.valid?
        expect(form.errors.messages.keys).to_not include(:venue_id)
        expect(form.errors.messages.keys).to_not include(:venue)
      end
    end

    # it "is invalid if there are both a venue_id and a venue" do
    #   form = EventForm.new(venue: double(valid?: false), venue_id: "1")
    #   form.valid?
    #   expect(form.errors.messages).to include(venue: ["You must choose a venue id OR new venue details, but not both"])
    # end


    # TODO: Validate whether the venue_id is real or not.
    # Not sure this can be done without requiring Rails
    # Maybe the approach is to inject a VenueFinder
    # it "is valid if there is a venue_id which matches a real venue" do
    #   allow(Venue).to receive(:find).with(23).and_return(double)
    #   form = EventForm.new(venue_id: 23)
    #   form.valid?
    #   expect(form.errors.messages.keys).to_not include(:venue_id)
    # end

    # it "is invalid if there is a venue_id which doesn't match a real venue" do
    #   form = EventForm.new(venue_id: 23)
    #   form.valid?
    #   expect(form.errors.messages).to include(venue_id: ["doesn't exist"])
    # end
  end

  describe ".errors" do
    it "responds to 'any?'" do
      expect{ EventForm.new.errors.any? }.to_not raise_error
    end
  end

  describe "#model_name" do
    it "returns the name of the form" do
      expect(EventForm.new.model_name.name).to eq "EventForm"
    end
  end
end

