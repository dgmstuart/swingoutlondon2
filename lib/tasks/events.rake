namespace :events do
  desc 'Generates event instances for all events'
  task generate_all: :environment do
    EventPeriod.generate_all
  end
end
