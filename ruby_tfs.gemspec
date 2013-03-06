# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.add_dependency 'ruby_odata'

  spec.add_development_dependency 'bundler', '~> 1.0'

  spec.authors = ["Luke van der Hoeven"]
  spec.description = %q{A Ruby interface to the TFS OData API.}
  spec.email = ['hungerandthirst@gmail.com']
  spec.files = %w(Rakefile LICENSE.md README.md ruby_tfs.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.homepage = 'https://github.com/BFGCOMMUNICATIONS/ruby_tfs'
  spec.licenses = ['APLv2']
  spec.name = 'ruby_tfs'
  spec.require_paths = ['lib']
  spec.required_rubygems_version = '>= 1.3.6'
  spec.summary = spec.description
  spec.test_files = Dir.glob("spec/**/*")
  spec.version = "0.0.3"
end