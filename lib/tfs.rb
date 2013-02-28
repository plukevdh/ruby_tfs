require 'tfs/client'

module TFS
  def self.client(options)
    Client.new(options)
  end
end