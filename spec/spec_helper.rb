# frozen_string_literal: true

require 'bundler/setup'
require_relative 'support/config/simplecov'
require_relative '../lib/rom/mongo'

rspec_custom = ::File.join(::File.dirname(__FILE__), 'support/**/*.rb')
::Dir[::File.expand_path(rspec_custom)].each { |file| require file unless file[/\A.+_spec\.rb\z/] }

RSpec::Mocks.configuration.allow_message_expectations_on_nil = true
RSpec.configure do |config|
  config.order = :random
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with(:rspec) { |c| c.syntax = :expect }

  config.include ROM::Mongo::ContextGeneratorHelper
  config.include ROM::Mongo::IntegrationHelper, type: :integration

  ::Kernel.srand(config.seed)
end
