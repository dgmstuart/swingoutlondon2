guard :rspec, cmd: "zeus rspec --tag ~js", all_after_pass: true, failed_mode: :none do
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

  # Test controllers through acceptance specs:
  watch('app/controllers/dates_controller.rb')           { "spec/acceptance/add_dates_spec.rb" }
  watch('app/controllers/events_controller.rb')          { ["spec/acceptance/create_event", "spec/acceptance/add_date_spec.rb"] }
  watch('app/controllers/event_instances_controller.rb') { ["spec/acceptance/create_event"] }
  watch('app/controllers/venues_controller.rb')          { ["spec/acceptance/create_event"] }
  watch('app/controllers/cancellations_controller.rb')   { ["spec/acceptance/cancel_event_spec.rb"] }
  watch('app/controllers/dance_classes_controller.rb')   { ["spec/acceptance/create_dance_class_spec.rb"] }

  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})     { |m| "spec/acceptance/" }

  # TODO: is it worth being more specific about which acceptance specs are relevant to which views?
  #   This would be a start:
  # watch('app/views/events/show.html.haml')          { ["spec/acceptance/create_event", "spec/acceptance/cancel_event_spec.rb"] }
  # watch('app/views/dance_classes/new.html.haml')    { ["spec/acceptance/create_dance_class_spec.rb"] }

  watch(['app/models/concerns/sortable.rb', 'spec/models/shared_examples/shared_examples_for_sortable.rb']) { ["spec/models/event_spec.rb", "spec/models/venue_spec.rb"] }

  # TODO: is it worth being more specific here?
  watch(%r{^spec/fabricators/.*\.rb$}) { |m| "spec" }
end

guard :bundler do
  watch('Gemfile')
end
