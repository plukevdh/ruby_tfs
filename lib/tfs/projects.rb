require 'tfs/work_items'
require 'tfs/branches'

module TFS
  class Projects < Queryable
    add_child TFS::WorkItems
    add_child TFS::Builds
    add_child TFS::Changesets
    add_child TFS::Branches

    class << self
      # Projects can be found by name alone
      #
      #     TFS::Projects.find("BFG")
      #
      def find(name)
        TFS.projects(name).run.first
      end
    end
  end
end
