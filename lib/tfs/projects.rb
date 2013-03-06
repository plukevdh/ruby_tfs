require 'tfs/work_items'

module TFS
  class Projects < Queryable
    add_child TFS::WorkItems
    add_child TFS::Builds
    add_child TFS::Changesets

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