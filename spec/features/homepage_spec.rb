require 'rails_helper'

RSpec.feature 'Homepage' do
  scenario 'showing socials and classes' do
    a_sunday_in_the_past = Date.new(1983, 4, 3)
    Timecop.freeze(a_sunday_in_the_past) do
      sunday_class = Fabricate.create(:dance_class, day: 0)
      tuesday_class = Fabricate.create(:dance_class, day: 2)
      wednesday_class = Fabricate.create(:dance_class, day: 3)

      past_event = Fabricate.create(:event_instance, date: Date.yesterday)
      today_event = Fabricate.create(:event_instance, date: Time.zone.today)
      tomorrow_event = Fabricate.create(:event_instance, date: Date.tomorrow)
      future_event = Fabricate.create(:event_instance, date: Time.zone.today + 5)
      far_future_event = Fabricate.create(:event_instance, date: Time.zone.today + 15)

      visit '/'
      aggregate_failures do
        within '#sunday' do
          expect(page).to have_content('Sunday')
          expect(page).to have_content(sunday_class.venue.postcode)
        end
        within '#monday' do
          expect(page).to have_content('Monday')
          expect(page).to have_content('There are no classes on this day')
        end
        within '#tuesday' do
          expect(page).to have_content('Tuesday')
          expect(page).to have_content(tuesday_class.venue.postcode)
        end
        within '#wednesday' do
          expect(page).to have_content('Wednesday')
          expect(page).to have_content(wednesday_class.venue.postcode)
        end
        within '#thursday' do
          expect(page).to have_content('Thursday')
          expect(page).to have_content('There are no classes on this day')
        end
        within '#friday' do
          expect(page).to have_content('Friday')
          expect(page).to have_content('There are no classes on this day')
        end
        within '#saturday' do
          expect(page).to have_content('Saturday')
          expect(page).to have_content('There are no classes on this day')
        end

        within '#1983-04-03' do
          expect(page).to have_content('TODAY: Sunday 3rd April')
          expect(page).to have_link(
            today_event.event_seed.event.name,
            href: today_event.url
          )
        end
        within '#1983-04-04' do
          expect(page).to have_content('TOMORROW: Monday 4th April')
          expect(page).to have_link(
            tomorrow_event.event_seed.event.name,
            href: tomorrow_event.url
          )
        end
        within '#1983-04-08' do
          expect(page).to have_content('Friday 8th April')
          expect(page).to have_link(
            future_event.event_seed.event.name,
            href: future_event.url
          )
        end

        expect(page).to_not have_content('Saturday 2nd April')
        expect(page).to_not have_content(past_event.event_seed.event.name)

        expect(page).to_not have_content('Monday 18th April')
        expect(page).to_not have_content(far_future_event.event_seed.event.name)
      end
    end
  end
end
