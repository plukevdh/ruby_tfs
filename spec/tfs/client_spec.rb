require 'spec_helper'

describe TFS::Client do
  let(:provider) { flexmock(:provider) }
  let(:client) { TFS::Client.new(provider: provider) }

  it "should be able to connect to tfs with defaults" do
    client = TFS::Client.new(endpoint: "http://fake.tfs.net/tfs:8080",
      username: "test", password: "123", provider: provider)

    provider.should_receive(new: true).with("http://fake.tfs.net/tfs:8080",
      {:username=>"test", :password=>"123",
       :headers=>{:accept=>"application/json", :user_agent=>"TFS Ruby Gem"},
       :request=>{:open_timeout=>5, :timeout=>10},
       :verify_ssl=>false}).once

    client.connect
  end

  context "with odata" do
    use_vcr_cassette "changesets"

    let(:client) { TFS::Client.new(endpoint: "https://tfs-dev-01/DefaultCollection",
      username: 'bfgcom\apiservice', password: 'BFGservice123') }

    before do
      client.connect
    end

    it "creates queries for data" do
      results = client.changesets
      results.should be_a(TFS::QueryEngine)
      results.type.should == TFS::Changesets
    end
  end
end