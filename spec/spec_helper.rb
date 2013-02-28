require 'rubygems'
require 'rspec'
require 'vcr'
require 'mailroute'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  # TODO: add header matching
  c.default_cassette_options = { :match_requests_on => [:method, :uri] }
  c.configure_rspec_metadata!
end
