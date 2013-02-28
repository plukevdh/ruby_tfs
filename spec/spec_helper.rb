require 'rspec'
require 'vcr'

require 'flexmock'
require 'webmock'

require 'simplecov'

require_relative '../lib/tfs.rb'

SimpleCov.start do
  add_filter "spec/"
  add_filter ".gems/"
end

VCR.config do |config|
  config.cassette_library_dir     = 'spec/cassettes'
  config.stub_with                :webmock
  config.default_cassette_options = { :record => :new_episodes }
end

RSpec.configure do |config|
  config.extend     VCR::RSpec::Macros
  config.mock_with  :flexmock
end