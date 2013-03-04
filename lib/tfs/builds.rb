module TFS
  class Builds < Queryable
    STATES = %w(All
                Failed
                InProgress
                None
                NotStarted
                PartiallySucceeded
                Stopped
                Succeeded)

    class << self

      # To do an explicit build find, the API requires the definiton the build is from,
      # the project it exists within, and the build number.
      #
      #     TFS::Builds.find("DevBuild", "My New Project", 'DevBuild.3')
      #
      def find(definition, project, number)
        TFS.builds("Definition='#{definition}',Project='#{project}',Number='#{number}'").run.first
      end
    end
  end
end