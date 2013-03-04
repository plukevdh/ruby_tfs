require 'spec_helper'

describe TFS do
  let(:odata) { flexmock(:odata) }
  let(:client) { TFS.client }

  before do
    TFS.configure do |config|
      config.endpoint = "http://fake.tfs.com:8080/tfs"
      config.provider = flexmock(:provider, new: odata)
    end
  end

  it "creates a client" do
    client.should be_a TFS::Client
    client.endpoint.should == "http://fake.tfs.com:8080/tfs"
  end

  it "aliases methods to the client" do
    flexmock(client, :connect_as)
    client.should_receive(:connect).once

    TFS.connect
  end
end