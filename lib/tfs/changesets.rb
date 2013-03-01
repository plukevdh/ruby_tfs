module TFS
  class Changesets
    class << self
      def all
        TFS.client.get(:changesets)
      end

      def find(id)
      end
    end
  end
end