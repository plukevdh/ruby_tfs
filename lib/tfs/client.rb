require 'active_support/core_ext/hash/indifferent_access'
require 'ruby_odata'

module TFS
  class Client
    REQUIRED_ATTRS = [:endpoint]

    attr_reader *REQUIRED_ATTRS

    def initialize(options, provider=OData::Service)
      options.to_options!

      REQUIRED_ATTRS.each do |attr|
        raise ArgumentError, "Missing #{attr} a required attribute." unless options.has_key? attr.to_sym
        instance_variable_set "@#{attr}", options[attr]
      end

      @provider = provider
    end

    # Options specific to the provider (odata in this case)
    PROVIDER_OPTIONS = [:username, :password, :verify_ssl]

    def connect_as(options)
      @client = @provider.new endpoint, filter_for_provider(options)
    end

    private

    def filter_for_provider(options)
      options.select {|k,v| PROVIDER_OPTIONS.include? k }
    end
  end
end