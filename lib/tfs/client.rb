require 'ruby_odata'
require 'tfs/configuration'

require 'tfs/class_helpers'
require 'tfs/query_engine'

module TFS
  class Client
    include TFS::Configuration
    extend TFS::ClassHelpers

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
      @connection ||= @provider.new endpoint, opts_for_connection
    end

    TFS::QueryEngine::VALID_CLASSES.each do |klass|
      define_method(base_class(klass).downcase) do |*params|
        TFS::QueryEngine.new(klass, @connection, params)
      end
    end

    def run
      @connection.execute
    end

    def method_missing(method_name, *args, &block)
      return super unless @connection.respond_to? method_name
      @connection.send(method_name, *args, &block)
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