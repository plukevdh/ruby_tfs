require 'spec_helper'

describe TFS::Client do
  let(:provider) { flexmock(:provider) }
  let(:client) { TFS::Client.new({}, provider) }

  it "should be able to connect to tfs with defaults" do
    client = TFS::Client.new({endpoint: "http://fake.tfs.net/tfs:8080",
      username: "test", password: "123"}, provider)

    provider.should_receive(new: true).with("http://fake.tfs.net/tfs:8080",
      {:username=>"test", :password=>"123",
       :headers=>{:accept=>"application/json", :user_agent=>"TFS Ruby Gem"},
       :request=>{:open_timeout=>5, :timeout=>10},
       :ssl=>{:verify=>false}}).once

    client.connect
  end
end