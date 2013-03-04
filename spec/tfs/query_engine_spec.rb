require 'spec_helper'


describe TFS::QueryEngine do
  class TFS::Builds; end
  let(:native_query) { flexmock(:queryable) }
  let(:conn) { flexmock(:connection, "Builds" => native_query) }

  it "raises an error if we try to create a query for a bad object" do
    expect { TFS::QueryEngine.new(String, conn) }.to raise_error(TypeError, /String is not/)
    expect { TFS::QueryEngine.new(TFS::Builds, conn) }.to_not raise_error
  end

  it "can chain queries" do
    query = TFS::QueryEngine.new(TFS::Builds, conn)

    native_query.should_receive(:top).with(10).and_return(native_query).once
    native_query.should_receive(:order_by).with("Reason").and_return(native_query).once

    query.limit(10).order_by("Reason")
  end

  it "can include other results" do
    query = TFS::QueryEngine.new(TFS::Builds, conn)
    native_query.should_receive(:expand).with('Changesets').and_return(native_query).once

    query.include(TFS::Changesets)
  end

  it "raises error if expand by invalid class" do
    query = TFS::QueryEngine.new(TFS::Builds, conn)

    expect { query.include('String') }.to raise_error(TypeError)

    native_query.should_not have_received(:expand)
  end
end