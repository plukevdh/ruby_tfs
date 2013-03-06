require 'spec_helper'

@pending
describe TFS::Builds do
  let(:client) { TFS.client }

  before do
    TFS.configure do |config|
      config.endpoint = "https://codeplexodata.cloudapp.net/TFS29"
      config.username ='snd\plukevdh_cp'
      config.password = 'garbage'
    end
  end

  # TODO: Very poor testing against Codeplex
  #       because we have no builds. Eventually
  #       migrating this over to visualstudio.com
  context "finders" do
    use_vcr_cassette 'builds'

    it "can get builds from TFS, limits to 50" do
      results = TFS::Builds.all
      results.count.should == 0
    end

    it "can get a specific build" do
      expect { TFS::Builds.find('rubytfs_demo', 'rubytfs', 1) }.to raise_error(TFS::Queryable::RecordNotFound)
    end

    it "can query in the raw" do
      results = TFS::Builds.odata_query("Status eq 'Succeeded'").limit(5).run
      results.each do |build|
        build.Status.should == 'Succeeded'
      end
      results.count.should == 0
    end
  end
end