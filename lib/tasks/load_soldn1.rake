desc 'Load in data from a Swing Out London v1 database'
task :load_soldn1, :dump do |_t, args|
  unless args[:dump]
    puts 'Error - you need to pass the location of the database dump as an argument'
    next
  end
  unless File.exist?(args[:dump])
    puts "#{args[:dump]}: No such file or directory"
    next
  end
  puts 'Re-setting the database...'
  Rake::Task['db:reset'].invoke
  puts 'Loading data...'
  system("psql soldn2_dev < #{args[:dump]}")
  puts 'Seeding the new database...'
  Rake::Task['db:seed'].invoke
  puts 'Generating event instances'
  Rake::Task['events:generate_all'].invoke
end
