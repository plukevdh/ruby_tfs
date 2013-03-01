# Lots of these ideas were stolen from the spectacular
# [sferik/twitter gem](https://github.com/sferik/twitter) gem
module TFS
  module Configuration
    extend Forwardable

    attr_writer :username, :password
    attr_accessor :endpoint, :connection_options

    def_delegator :options, :hash

    CONNECTION_OPTIONS = {
      :headers => {
        :accept => 'application/json',
        :user_agent => "TFS Ruby Gem",
      },
      :request => {
        :open_timeout => 5,
        :timeout => 10,
      },
      :ssl => {
        :verify => false
      },
    } unless defined? TFS::Configuration::CONNECTION_OPTIONS

    class << self
      def keys
        @keys ||= [
          :username,
          :password,
          :endpoint,
          :connection_options,
        ]
      end

      def connection_options
        CONNECTION_OPTIONS
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

      def options
        Hash[Configuration.keys.map{|key| [key, send(key)]}]
      end
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
  end
end