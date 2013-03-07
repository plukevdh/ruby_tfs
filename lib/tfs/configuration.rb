# Lots of these ideas were stolen from the spectacular
# [sferik/twitter gem](https://github.com/sferik/twitter) gem
module TFS
  module Configuration
    extend Forwardable

    attr_writer :username, :password
    attr_accessor :endpoint, :connection_options, :provider, :namespace

    def_delegator :options, :hash

    CONNECTION_DEFAULTS = {
      rest_options: {
        headers: {
          user_agent: "TFS Ruby Gem"
        },
        request: {
          open_timeout: 5,
          timeout: 10,
        },
      },
      verify_ssl: false
    } unless defined? TFS::Configuration::CONNECTION_DEFAULTS

    class << self
      def keys
        @keys ||= [
          :username,
          :password,
          :endpoint,
          :connection_options,
          :provider,
          :namespace
        ]
      end

      def connection_options
        CONNECTION_DEFAULTS
      end

      def username
        ENV['TFS_USERNAME']
      end

      def password
        ENV['TFS_PASSWORD']
      end

      def endpoint
        ENV['TFS_ENDPOINT']
      end

      def provider
        OData::Service
      end

      def options
        Hash[Configuration.keys.map{|key| [key, send(key)]}]
      end

      # No default namespace
      def namespace ; end
    end

    def configure
      yield self
      self
    end

    def reset!
      TFS::Configuration.keys.each do |key|
        instance_variable_set(:"@#{key}", Configuration.options[key])
      end
      self
    end
    alias setup reset!

    private
    def options
      Hash[TFS::Configuration.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

    def client_options
      connection_options.merge(username: @username, password: @password, namespace: @namespace)
    end
  end
end