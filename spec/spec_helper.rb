if ENV['COVERAGE'] && RUBY_VERSION !~ /^1\.8/
  require 'simplecov'
  SimpleCov.start
end

require 'rubygems'
require 'rspec'
require 'vcr'
require 'awesome_print'

require 'mailroute'

require 'support/mailroute_configuration_helper'
require 'support/custom_matchers'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  # TODO: add header matching
  c.default_cassette_options = { :match_requests_on => [:method, :uri] }
  c.configure_rspec_metadata!
end

RSpec.configure do |c|
  c.include MailrouteConfigurationHelper
end