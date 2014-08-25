namespace :events do
  desc "Generates event instances for all events"
  task generate_all: :environment do
    EventGenerator.generate_all
  end
end
