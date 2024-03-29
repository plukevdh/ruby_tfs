require 'spec_helper'

describe TFS::Changesets do
  let(:client) { TFS.client }
  before do
    TFS.configure do |config|
      config.endpoint = "https://codeplexodata.cloudapp.net/TFS29"
      config.username ='snd\plukevdh_cp'
      config.password = 'garbage'
    end
  end

  context "finders" do
    use_vcr_cassette 'changesets'

    it "can get changesets from TFS" do
      results = TFS::Changesets.all
      results.count.should == 2
    end

    it "can get a project by name" do
      result = TFS::Changesets.find(23460)
      result.Comment.should =~ /use the repo to persist\/update/
    end

    it "can query in the raw" do
      results = TFS::Changesets.odata_query("Committer eq 'plukevdh_cp'").run
      results.each do |build|
        build.Committer.should end_with 'plukevdh_cp'
      end
      results.count.should == 1
    end
  end
end
