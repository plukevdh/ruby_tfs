require 'tfs/queryable'
require 'tfs/branches'
require 'tfs/builds'
require 'tfs/changesets'
require 'tfs/changes'
require 'tfs/projects'
require 'tfs/work_items'
require 'tfs/area_paths'

module TFS
  class QueryEngine
    extend Forwardable
    include TFS::ClassHelpers

    attr_reader :type


    # Classes we currently support queries on
    VALID_CLASSES = [
      TFS::Branches,
      TFS::Builds,
      TFS::Changesets,
      TFS::Projects,
      TFS::WorkItems,
      TFS::Changes,
      TFS::AreaPaths
    ]

    # Default pagination `#all` limit
    # for all other actions, it limits by default to 20 (API level limit)
    DEFAULT_LIMIT = 50

    # A new query requres a base class (of one of the above `VALID_CLASSES`),
    # a connection (from `client.connection`) and can take additional selection parameters
    #
    #     TFS::QueryEngine(TFS::Projects, TFS.client.connection, 'project-name')
    #
    def initialize(for_class, connection, params="")
      check_type(for_class)
      @type, @connection = for_class, connection

      @native_query = @connection.send(base_class(for_class), normalize(params))
    end

    # Returns the underlying `OData::QueryBuilder` object in case you want to work
    # directly against the odata adapter
    def raw
      @native_query
    end

    # Limit records returned
    def limit(count)
      @native_query = @native_query.top(count)
      self
    end

    # Ordering. Must be a valid field
    def order_by(query)
      @native_query = @native_query.order_by(query)
      self
    end

    # Filtering, use odata query syntax
    def where(filter)
      @native_query = @native_query.filter(filter)
      self
    end

    # Return a count of records rather than records
    def count
      @native_query = @native_query.count
      self
    end

    # For pagination. Skips supplied number of records
    def page(start)
      @native_query = @native_query.skip(start)
      self
    end

    # Required to execute the query
    def run
      @connection.execute
    end

    # Returns the actual query string (does not run query)
    def to_query
      @native_query.query
    end

    def method_missing(method_name, *args, &block)
      return super unless @type.send "#{method_name}?".to_sym
      @native_query.navigate(odata_class_from_method_name(method_name))
      self
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