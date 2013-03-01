require 'tfs/client'

module TFS
  # Wrapper for TFS::Client.new
  class << self
    include Configuration

    # Shortcut to create and connect a client
    def client
      @client = begin
        client = Client.new(options)
        client.connect
        client
      end unless defined?(@client) && @client.hash == options.hash

      @client
    end

    def respond_to_missing?(method_name, include_private=false); client.respond_to?(method_name, include_private); end if RUBY_VERSION >= "1.9"
    def respond_to?(method_name, include_private=false); client.respond_to?(method_name, include_private) || super; end if RUBY_VERSION < "1.9"

    private
    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end
  end
end

TFS.setup