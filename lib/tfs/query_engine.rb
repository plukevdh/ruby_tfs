require 'tfs/queryable'
require 'tfs/builds'
require 'tfs/changesets'
require 'tfs/projects'

module TFS
  class QueryEngine
    extend Forwardable

    attr_reader :type

    VALID_CLASSES = [
      TFS::Builds,
      TFS::Changesets,
      TFS::Projects
    ]

    DEFAULT_LIMIT = 50

    def initialize(for_class, connection, params="")
      raise TypeError, "#{for_class.name} is not a valid query type." unless VALID_CLASSES.include? for_class
      @type, @connection = for_class, connection

      @native_query = @connection.send(for_class.name.split("::").last, params)
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
      @native_query = @native_query.filter(filter)
      self
    end

    def count
      @native_query = @native_query.count
      self
    end

    def page(start)
      @native_query = @native_query.skip(start)
      self
    end

    def run
      @connection.execute
    end

    def to_query
      @native_query.query
    end
  end
end