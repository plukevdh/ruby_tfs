module TFS
  class Projects < Queryable
    class << self

      # Projects can be found by name alone
      #
      #     TFS::Projects.find("BFG")
      #
      def find(name)
        TFS.projects("'#{name}'").run.first
      end
    end
  end
end