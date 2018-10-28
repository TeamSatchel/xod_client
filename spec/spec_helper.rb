require 'bundler/setup'
require 'xod_client'
require 'vcr'
require 'active_support/testing/time_helpers'

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with(:rspec) { |c| c.syntax = :expect }

  include ActiveSupport::Testing::TimeHelpers
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
end
