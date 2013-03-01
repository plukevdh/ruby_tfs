require 'ruby_odata'
require 'tfs/configuration'

require 'tfs/query_engine'

module TFS
  class Client
    include TFS::Configuration

    # Options specific to the provider (odata in this case)
    PROVIDER_OPTIONS = [:username, :password, :verify_ssl]

    attr_reader :connection, :endpoint

    # Creates an instance of the client
    def initialize(options={})
      TFS::Configuration.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || TFS.instance_variable_get(:"@#{key}"))
      end
    end

    # Creates the connection to the data provider source
    def connect
      @connection = @provider.new endpoint, opts_for_connection
    end

    def builds
      create_query(Builds)
    end

    def changesets
      create_query(Changesets)
    end

    def run
      @connection.execute
    end

    private

    def create_query(klass)
      TFS::QueryEngine.new(klass, @connection)
    end

    def opts_for_connection
      {
        username: @username,
        password: @password
      }.merge connection_options
    end
  end
end