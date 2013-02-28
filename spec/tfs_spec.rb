require 'spec_helper'

describe TFS do
  before do
    TFS.configure do |config|
      config.endpoint = "http://fake.tfs.com:8080/tfs"
    end
  end

  let(:client) { TFS.client }

  it "creates a client" do
    client.should be_a TFS::Client
    client.endpoint.should == "http://fake.tfs.com:8080/tfs"
  end

  it "aliases methods to the client" do
    flexmock(client, :connect_as)
    client.should_receive(:connect_as).once

    TFS.connect_as(username: "lukas", password: "test")
  end
end