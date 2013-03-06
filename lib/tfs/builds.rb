require 'tfs/work_items'
require 'tfs/changesets'

module TFS
  class Builds < Queryable
    add_child TFS::WorkItems
    add_child TFS::Changesets

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
        begin
          TFS.builds(definition: definition, project: project, number: number).run.first
        rescue RestClient::ResourceNotFound => e
          raise Queryable::RecordNotFound, "No record found for '#{definition}', '#{project}', #{number}"
        end
      end
    end
  end
end