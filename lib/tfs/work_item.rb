module TFS
  class WorkItem
    TYPES = []

    InvalidRecord = Class.new(StandardError)

    REQUIRED_PARAMS = [
      "Title",
      "Type",
      "Project"
    ]

    def initialize(client)
      @client = client
      @work_item = ::WorkItem.new
    end

    def save
      REQUIRED_PARAMS.each do |param|
        raise InvalidRecord, "Missing required parameter '#{param}'" if @work_item.send(param).nil?
      end

      @client.AddToWorkItems(@work_item)
      item = @client.save_changes
      item.first
    end

    def update
      @client.update_object(@work_item)
      @client.save_changes
    end

    def method_missing(method_name, *args, &block)
      return super unless @work_item.respond_to? method_name
      @work_item.send(method_name, *args, &block)
    end
  end
end