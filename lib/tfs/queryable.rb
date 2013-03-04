module TFS
  class Queryable
    class << self
      include TFS::ClassHelpers
      # Always limit to the default limit of 50 so as not to overwhelm the service
      # If more are required, set `#limit` explicitly.
      def all
        get_query.limit(QueryEngine::DEFAULT_LIMIT).run
      end

      def inherited(klass)
        klass.instance_eval do
          def add_child(child_class)

            klass.class_eval do
              define_method method_name_from_class(child_class).to_sym do

              end
            end

          end
        end
      end

      # #odata_query allows you to access the raw query sytax provide by the OData api
      #
      #     TFS::Builds.odata_query('Status eq "Succeeded"')
      #
      def odata_query(raw_query)
        get_query.where(raw_query)
      end
      alias :where :odata_query

      private
      def get_query
        TFS.send(method_name_from_class)
      end
    end
  end
end

# Eventually I'd like to see a query compiler that makes more
# "ruby like" queries possible, instead of forcing users to use the OData
# query api. For now, this is good enough.