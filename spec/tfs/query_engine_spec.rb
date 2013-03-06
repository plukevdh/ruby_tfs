require 'spec_helper'


describe TFS::QueryEngine do
  class TFS::Builds; end
  let(:native_query) { flexmock(:queryable) }
  let(:conn) { flexmock(:connection, "Builds" => native_query) }
  let(:query) { TFS::QueryEngine.new(TFS::Builds, conn) }

  it "raises an error if we try to create a query for a bad object" do
    expect { TFS::QueryEngine.new(String, conn) }.to raise_error(TypeError, /String is not/)
    expect { TFS::QueryEngine.new(TFS::Builds, conn) }.to_not raise_error
  end

  it "can query in the raw" do
    native_query.should_receive(:filter).with("Sup my homies")

    query.raw.filter("Sup my homies")
  end

  it "can chain queries" do
    native_query.should_receive(:top).with(10).and_return(native_query).once
    native_query.should_receive(:order_by).with("Reason").and_return(native_query).once

    query.limit(10).order_by("Reason")
  end

  it "can include other results" do
    native_query.should_receive(:expand).with('Changesets').and_return(native_query).once

    query.include(TFS::Changesets)
  end

  it "raises error if expand by invalid class" do
    expect { query.include('String') }.to raise_error(TypeError)

    native_query.should_not have_received(:expand)
  end

  it "can cause pagination" do
    native_query.should_receive(:skip).with(10)
    query.page(10)
  end

  context "with real odata" do
    let(:query) { TFS::QueryEngine.new(TFS::Builds, TFS.client) }

    it "can send count" do
      native_query.should_receive(:filter).pass_thru
      native_query.should_receive(:count)

      query.where("Something eq test").count
    end

    it "can print the proposed query" do
      native_query.should_receive(:filter).pass_thru
      native_query.should_receive(:skip).with(10).pass_thru

      query_string = query.where("Something eq 'test'").page(10).to_query
      query_string.should == "/Builds('')?$filter=Something+eq+%27test%27&$skip=10"
    end
  end

  context "normalize" do
    it "strings" do
      val = query.send :normalize, ["hello world"]
      val.should == "'hello world'"
    end

    it "arrays" do
      val = query.send :normalize, [["twitter", "facebook"]]
      val.should == "'twitter','facebook'"
    end

    it "hashes" do
      val = query.send :normalize, [{coke: "jack", salt: "vinegar", "something" => "fake"}]
      val.should == "Coke='jack',Salt='vinegar',Something='fake'"
    end

    it 'anything else' do
      val = query.send :normalize, [1]
      val.should == 1
    end

  end
end