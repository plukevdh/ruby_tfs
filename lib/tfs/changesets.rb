module TFS
  class Changesets < Queryable
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