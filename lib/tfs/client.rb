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
    def connect
      @connection = @provider.new endpoint, opts_for_connection
    end

    private
    def opts_for_connection
      {
        username: @username,
        password: @password
      }.merge connection_options
    end
  end
end