RSpec.configure do |config|
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

  config.example_status_persistence_file_path = '/tmp/rspec_failures'
end

$LOAD_PATH << File.expand_path("../../", __FILE__)
