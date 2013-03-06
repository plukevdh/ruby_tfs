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
    let(:client) { TFS::Client.new(endpoint: "https://codeplexodata.cloudapp.net/TFS29",
      username: 'snd\plukevdh_cp', password: 'garbage') }

    context "individual queries" do
      use_vcr_cassette "changeset_queries"

      before do
        client.connect
      end

      it "creates queries for data" do
        results = client.changesets
        results.should be_a(TFS::QueryEngine)
        results.type.should == TFS::Changesets
      end

      it "can query with a nice api" do
        project = client.projects("rubytfs").run
        project.size.should == 1
        project.first.Name.should == "rubytfs"
      end

      it "can execute queries" do
        client.projects("rubytfs")
        projects = client.run

        projects.size.should == 1
        projects.first.Name.should == "rubytfs"
      end

    end

    context "sub queries" do
      use_vcr_cassette "project_changesets"

      before do
        client.connect
      end

      it "can traverse/filter by sub items (children)" do
        changesets = client.projects('rubytfs').changesets.run
        changesets.count.should == 2
        changesets.first.should be_a Changeset
      end
    end

    context "special cases" do
      use_vcr_cassette "project_workitems"

      before do
        client.connect
      end

      it "can traverse special case classes" do
        work_items = client.projects('rubytfs').workitems.run
        work_items.count.should == 19
        work_items.first.should be_a WorkItem
      end

      it "can't traverse unrelated items" do
        expect { client.projects('rubytfs').weed }.to raise_error(NoMethodError)
      end
    end
  end
end