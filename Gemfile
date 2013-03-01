source :rubygems

gem 'rake'

group :development do
  gem 'pry'
  gem 'pry-debugger', :platforms => :mri_19
end

group :test do
  gem 'rspec'
  gem 'vcr', require: false
  gem 'webmock', "< 1.10"
  gem 'flexmock'
  gem 'simplecov', require: false
end


gem 'rest-client', git: "https://github.com/plukevdh/rest-client.git"
gemspec
