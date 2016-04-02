require 'spec_helper'
require 'active_model'
require 'app/forms/venue_form'

RSpec.describe VenueForm do
  describe "#id" do
    it "converts the passed in id to a number" do
      expect(VenueForm.new(id: "23").id).to eq 23
    end

    it "returns nil if no id was passed in" do
      expect(VenueForm.new(id: "").id).to eq nil
    end
  end

  describe "#name" do
    it "returns the passed in name" do
      expect(VenueForm.new(name: "The Lady Luck Club").name).to eq "The Lady Luck Club"
    end
  end

  describe "#address" do
    it "returns the passed in address" do
      expect(VenueForm.new(address: "1 High Holborn, London").address).to eq "1 High Holborn, London"
    end
  end

  describe "#postcode" do
    it "returns the passed in postcode" do
      expect(VenueForm.new(postcode: "N1 7NG").postcode).to eq "N1 7NG"
    end
  end

  describe "#url" do
    it "returns the passed in url" do
      expect(VenueForm.new(url: "https://ladyluckclub.com").url).to eq "https://ladyluckclub.com"
    end
  end

  describe "#create_venue" do
    it "returns true if create_venue is present" do
      expect(VenueForm.new(create_venue: "foo").create_venue).to eq true
    end

    it "returns nil if create_venue is missing" do
      expect(VenueForm.new.create_venue).to eq nil
    end
  end
end
