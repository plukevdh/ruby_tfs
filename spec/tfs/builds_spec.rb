require 'spec_helper'

describe TFS::Builds do
  let(:client) { TFS.client }

  context "finders" do
    use_vcr_cassette "all builds"

    it "can get builds from TFS" do
      results = TFS::Builds.all
      results.count.should == 50
    end

  end
end