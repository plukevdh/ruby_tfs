require 'tfs/changesets'

module TFS
  class Branches < Queryable
    add_child TFS::Changesets

    class << self
      # Branch can be found by path of the form $>Collection>Project
      #
      #     TFS::Branches.find($>DefaultCollection>Project)
      #
      def find(path)
        TFS.branches(path).run.first
      end
    end
  end
end