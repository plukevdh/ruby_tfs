module TFS
  class WorkItems < Queryable
    TYPES = []

    InvalidRecord = Class.new(StandardError)

    REQUIRED_PARAMS = [
      "Title",
      "Type",
      "Project"
    ]

    class << self
      # Changeset can be found by id alone
      #
      #     TFS::Changeset.find(123)
      #
      def find(id)
        TFS.workitems(id).run.first
      end

      def save(item)
        REQUIRED_PARAMS.each do |param|
          raise InvalidRecord, "Missing required parameter '#{param}'" if item.send(param).nil?
        end

        client.AddToWorkItems(item)
        item = client.save_changes
        item.first
      end

      def update(item)
        client.update_object(item)
        client.save_changes
      end

      private
      def client
        @client ||= TFS.client
      end
    end
  end
end