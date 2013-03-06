module TFS
  class Changes < Queryable

    class << self
      # Changes have to be scoped by changesets, so all requires we have a changeset id
      def all(changeset)
        TFS.changesets(changeset).changes
      end

      # Change can be found by changeset and path
      #
      #     TFS::Changes.find(123, '/path/to/change')
      #
      def find(changeset, path)
        TFS.changes({changeset: changeset, path: path}).run.first
      end
    end
  end
end