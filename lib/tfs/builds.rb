module TFS
  class Builds
    STATES = %w(All
                Failed
                InProgress
                None
                NotStarted
                PartiallySucceeded
                Stopped
                Succeeded)

    class << self
      def all
        TFS.builds.run
      end

      def find(definition, project, number)
        TFS.builds("Definition='#{definition}',Project='#{project}',Number='#{number}'").run.first
      end

      def odata_query(raw_query)
        TFS.builds.where(raw_query)
      end
    end
  end
end