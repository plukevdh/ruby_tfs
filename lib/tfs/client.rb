require 'active_support/core_ext/hash/indifferent_access'
require 'ruby_odata'
require 'tfs/configuration'

module TFS
  class Client
    include TFS::Configuration

    # Options specific to the provider (odata in this case)
    PROVIDER_OPTIONS = [:username, :password, :verify_ssl]

    attr_reader :connection, :endpoint

    # Creates an instance of the client
    def initialize(options={}, provider=OData::Service)
      TFS::Configuration.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || TFS.instance_variable_get(:"@#{key}"))
      end

      @provider = provider
    end

    # Creates the connection to the data provider source
    def connect_as(opts)
      @connection = @provider.new endpoint, filter_for_provider(opts)
    end

    private

    def filter_for_provider(opts)
      opts.select {|k,v| PROVIDER_OPTIONS.include? k }
    end
  end
end