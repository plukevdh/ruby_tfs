require 'tfs/changesets'
require 'tfs/changeset_merges'

module TFS
  class Branches < Queryable
    add_child TFS::Changesets
    add_child TFS::ChangesetMerges

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