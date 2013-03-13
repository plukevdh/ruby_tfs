require 'spec_helper'

@pending
describe TFS::AreaPaths do
  let(:client) { TFS.client }

  before do
    TFS.configure do |config|
      config.endpoint = "https://codeplexodata.cloudapp.net/TFS29"
      config.username ='snd\plukevdh_cp'
      config.password = 'garbage'
    end
  end

  # TODO: Very poor testing against Codeplex
  #       because we have no area paths. Eventually
  #       migrating this over to visualstudio.com
  context "finders" do
    use_vcr_cassette 'area_paths'

    it "can get paths from TFS, limits to 50" do
      results = TFS::AreaPaths.all
      results.count.should == 0
    end

    it "can get a specific area path" do
      expect { TFS::AreaPaths.find('test_path') }.to raise_error(TFS::Queryable::RecordNotFound)
    end

    it "can query in the raw" do
      results = TFS::AreaPaths.odata_query("Name eq 'Test Path'").limit(5).run
      results.each do |build|
        build.Name.should == 'Test Path'
      end
      results.count.should == 0
    end
  end
end