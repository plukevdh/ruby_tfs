require 'tfs/changes'

module TFS
  class Changesets < Queryable
    add_child TFS::Changes

    class << self
      # Changeset can be found by id alone
      #
      #     TFS::Changeset.find(123)
      #
      def find(id)
        TFS.changesets(id).run.first
      end
    end
  end
end