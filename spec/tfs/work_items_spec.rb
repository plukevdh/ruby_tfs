require 'spec_helper'

describe TFS::WorkItems do
  let(:client) { TFS.client }
  before do
    TFS.configure do |config|
      config.endpoint = "https://codeplexodata.cloudapp.net/TFS29"
      config.username ='snd\plukevdh_cp'
      config.password = 'garbage'
    end
  end

  context "finders" do
    use_vcr_cassette 'workitems'

    it "can get workitems from TFS" do
      results = TFS::WorkItems.all
      results.count.should == 18
    end

    it "can get a project by name" do
      result = TFS::WorkItems.find(1234)
      result.CreatedBy.should == "MCLWEB"
      result.AssignedTo.should == "plukevdh_cp"
    end

    it "can query in the raw" do
      results = TFS::WorkItems.odata_query("AssignedTo eq 'plukevdh_cp'").run
      results.each do |build|
        build.AssignedTo.should == 'plukevdh_cp'
      end
      results.count.should == 14
    end

    it "can add a work item" do
      temp = ::WorkItem.new(client)
      temp.Title = "A Testing Item."
      temp.AssignedTo = 'plukevdh_cp'
      temp.Description = "A Test WorkItem from ruby_tfs wrapper"
      temp.Type = "Work Item"
      temp.Project = "rubytfs"

      created = TFS::WorkItems.save(temp)

      item = TFS::WorkItems.where("Title eq '#{created.Title}'").limit(1).run.first
      item.AssignedTo.should == created.AssignedTo
      item.Type.should == created.Type
    end

    it "can update existing work items" do
      temp = TFS::WorkItems.find(1245)
      temp.Title = "I'm updated, son!!"

      saved = TFS::WorkItems.update(temp)
      item = TFS::WorkItems.find(temp.Id)

      saved.should be_true
      item.Title.should == temp.Title
    end

    it "throws error if missing param" do
      temp = ::WorkItem.new(client)
      temp.Title = "A Testing Item."

      expect { TFS::WorkItems.save(temp) }.to raise_error(TFS::WorkItems::InvalidRecord, /Missing required parameter 'Type'/)
    end
  end
end
