require 'tfs/builds'
require 'tfs/changesets'
require 'tfs/projects'

module TFS
  class QueryEngine
    extend Forwardable

    OBJECTS = [
      TFS::Builds,
      TFS::Changesets,
      TFS::Projects
    ]

    attr_reader :type

    def initialize(for_class, connection)
      raise TypeError, "#{for_class.to_s} is not a TFS object type" unless OBJECTS.include? for_class
      @type, @connection = for_class, connection

      @native_query = @connection.send(for_class.to_s.split("::").last)
    end

    def limit(count)
      @native_query = @native_query.top(count)
      self
    end

    def order_by(query)
      @native_query = @native_query.order_by(query)
      self
    end

    def where(filter)
      @native_query = @native_query.filter(query)
      self
    end

    def count
      @native_query = @native_query.count
      self
    end

    def run
      @connection.execute
    end
  end
end