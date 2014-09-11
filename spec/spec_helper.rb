require 'simplecov'
SimpleCov.start :rails do
  add_group "Validators", "app/validators"
  add_group "Forms", "app/forms"
end

require 'rspec/core' # Zeus won't work without this because otherwise something else (?) is defining Rspec (?) and doesn't have access to the configure method (???)

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.alias_example_to :ffeature, focus: true
  config.alias_example_to :fscenario, focus: true

  if config.files_to_run.one?
    # Use the documentation formatter for detailed output
    config.default_formatter = 'doc'
  end

  config.order = :random
  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end
  config.disable_monkey_patching!

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
end
