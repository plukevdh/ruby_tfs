require 'spec_helper'

describe TFS::Client do
  let(:client) { TFS::Client.new(endpoint: "http://fake.tfs.net/tfs:8080") }

  it "requires default attributes" do
    expect { TFS::Client.new(sup: "123") }.to raise_error(ArgumentError, /Missing endpoint/)
  end

  it "is indifferent to access" do
    client = TFS::Client.new "endpoint" => "http://fake.tfs.net/tfs:8080"
    client.endpoint.should == "http://fake.tfs.net/tfs:8080"
  end

  it "should be able to connect to tfs" do
    provider = flexmock(:provider)
    client = TFS::Client.new({endpoint: "http://fake.tfs.net/tfs:8080"}, provider)

    provider.should_receive(new: true).with("http://fake.tfs.net/tfs:8080", {username: "test", password: "password"}).twice

    client.connect_as(username: "test", password: "password")
    client.connect_as(username: "test", password: "password", bad_param: "123")
  end
end