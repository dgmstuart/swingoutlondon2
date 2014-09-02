require 'rails_helper'

feature "Admin adds a dance_class", type: :feature do
  given(:existing_venue) { Fabricate(:venue) }

  let(:dance_class) { Fabricate.build(:dance_class, day: 2) }

  before do
    user = Fabricate.create(:user)
    login_as(user, scope: :user)
  end

  scenario "standalone with valid data" do
    given_an_existing_venue
    when_i_create_a_new_dance_class_with_valid_data
    then_the_dance_class_should_be_displayed
    and_the_dance_class_should_be_displayed_in_the_list_of_dance_classes
  end

  def given_an_existing_venue
    existing_venue
  end

  def when_i_create_a_new_dance_class_with_valid_data
    visit '/dance_classes/new'
    within("#new_dance_class") do
      fill_dance_class_fields_with_valid_data
      select existing_venue.name, from: "dance_class[venue_id]"

      click_button 'Create dance class'
    end
  end

  def fill_dance_class_fields_with_valid_data
    fill_in "dance_class[day]", with: dance_class.day
  end

  def then_the_dance_class_should_be_displayed
    expect(page).to have_text "Tuesdays" # i.e. day: 2
    expect(page).to have_text existing_venue.name
  end

  def and_the_dance_class_should_be_displayed_in_the_list_of_dance_classes
    visit '/dance_classes'
    expect(page).to have_text "Tuesdays" # i.e. day: 2
    expect(page).to have_text existing_venue.name
  end
end