module TFS
  class AreaPaths < Queryable
    class << self
      # Changeset can be found by id alone
      #
      #     TFS::AreaPaths.find("area-path")
      #
      def find(area_path)
        begin
          TFS.areapaths(area_path).run.first
        rescue RestClient::ResourceNotFound => e
          raise Queryable::RecordNotFound, "No record found for '#{area_path}'"
        end
      end
    end
  end
end