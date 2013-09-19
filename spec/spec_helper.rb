require 'uri'
require 'rspec/expectations'
require "vcr"
require "webmock/rspec"

require File.join(File.dirname(__FILE__), "../lib/streamsend")

VCR.configure do |c|
  c.default_cassette_options = { :record => :new_episodes }
  c.cassette_library_dir = 'spec/integration/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.debug_logger = File.open("logfile.log", "w")
  c.filter_sensitive_data("<STREAMSEND_PASSWORD>") do
    ENV['STREAMSEND_PASSWORD']
  end
end

