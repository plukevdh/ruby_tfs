module TFS
  module Configuration
    extend Forwardable

    attr_writer :username, :password
    attr_accessor :endpoint, :connection_options

    def_delegator :options, :hash

    class << self
      def keys
        @keys ||= [
          :username,
          :password,
          :endpoint,
          :connection_options,
        ]
      end
    end

    def configure
      yield self
      self
    end

    private
    def options
      Hash[TFS::Configuration.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end
  end
end