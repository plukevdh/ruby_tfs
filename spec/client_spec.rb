require 'spec_helper'

describe TFS::Client do
  let(:client) { TFS::Client.new endpoint: "http://fake.tfs.net/tfs:8080" }

  it "should be able to connect to tfs" do
    provider = flexmock(:provider)
    client = TFS::Client.new({endpoint: "http://fake.tfs.net/tfs:8080"}, provider)

    provider.should_receive(new: true).with("http://fake.tfs.net/tfs:8080", {username: "test", password: "password"}).twice

    client.connect_as(username: "test", password: "password")
    client.connect_as(username: "test", password: "password", bad_param: "123")
  end
end