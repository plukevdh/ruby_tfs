require 'tfs/queryable'
require 'tfs/builds'
require 'tfs/changesets'
require 'tfs/projects'

require 'tfs/work_items'

module TFS
  class QueryEngine
    extend Forwardable
    include TFS::ClassHelpers

    attr_reader :type

    VALID_CLASSES = [
      TFS::Builds,
      TFS::Changesets,
      TFS::Projects,
      TFS::WorkItems
    ]

    DEFAULT_LIMIT = 50

    def initialize(for_class, connection, params="")
      check_type(for_class)
      @type, @connection = for_class, connection

      @native_query = @connection.send(base_class(for_class), normalize(params))
    end

    def raw
      @native_query
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

    def include(klass)
      check_type(klass)
      @native_query.expand(base_class(klass))
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

    private
    def check_type(for_class)
      raise TypeError, "#{for_class.to_s} is not a valid query type." unless VALID_CLASSES.include? for_class
    end

    def normalize(params)
      args = params.first
      case args
      when String
        format_parameter(args)
      when Array
        args.map {|item| format_parameter(item) }.join(",")
      when Hash
        args.map {|k,v| "#{k.to_s.capitalize}=#{format_parameter(v)}"}.join(',')
      else
        args
      end
    end

    def format_parameter(param)
      "'#{param}'"
    end
  end
end