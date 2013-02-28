require 'spec_helper'

describe TFS do
  it "creates a client" do
    client = TFS.client(endpoint: "http://tfs.test.com:8080")
    client.should be_a TFS::Client
    client.endpoint.should == "http://tfs.test.com:8080"
  end
end