guard :rspec, cmd: "zeus rspec", all_after_pass: true, failed_mode: :none do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }

  # Rails
  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
  watch('config/routes.rb')                           { "spec/routing" }
  watch('app/controllers/application_controller.rb')  { "spec/controllers" }

  watch('app/controllers/dates_controller.rb')  { "spec/acceptance/add_dates_spec.rb" }
  watch('app/controllers/events_controller.rb')  { ["spec/acceptance/create_event_spec.rb", "spec/acceptance/add_date_spec.rb"] }
  watch('app/controllers/event_instances_controller.rb')  { ["spec/acceptance/create_event_spec.rb"] }

  # Capybara features specs
  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})     { |m| "spec/features/#{m[1]}_spec.rb" }
end


guard :rails, cmd: "zeus server" do
  watch('Gemfile.lock')
  watch(%r{^(config|lib)/.*})
end

guard :bundler do
  watch('Gemfile')
end