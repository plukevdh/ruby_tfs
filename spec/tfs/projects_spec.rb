require 'spec_helper'

describe TFS::Projects do
  let(:client) { TFS.client }

  before do
    TFS.configure do |config|
      config.endpoint = "https://codeplexodata.cloudapp.net/TFS29"
      config.username ='snd\plukevdh_cp'
      config.password = 'garbage'
    end
  end

  context "finders" do
    use_vcr_cassette 'projects'

    it "can get projects from TFS" do
      results = TFS::Projects.all
      results.count.should == 1
    end

    it "can get a project by name" do
      result = TFS::Projects.find('rubytfs')
      result.Name.should == 'rubytfs'
    end

    it "can query in the raw" do
      results = TFS::Projects.odata_query("startswith(Name,'rubytfs')").run
      results.each do |build|
        build.Name.should start_with 'rubytfs'
      end
      results.count.should == 1
    end
  end
end