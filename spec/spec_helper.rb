require 'rspec'
require 'vcr'
require 'simplecov'

require_relative "../lib/tfs"

SimpleCov.start do
  add_filter "spec/"
  add_filter ".gems/"
end

VCR.configure do |config|
  config.cassette_library_dir     = 'spec/fixtures/cassettes'
  config.hook_into                :webmock
  config.default_cassette_options = { :record => :new_episodes }
end

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros
  config.mock_with  :flexmock
end

def load_result_fixture(fixture)
  path = File.join File.dirname(__FILE__), 'fixtures', fixture
  File.open(path) {|f| f.read }
end