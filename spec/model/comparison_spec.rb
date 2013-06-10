require 'spec_helper'

describe SORM::Models::Comparison do

  before do
    SORM.storage_config = { :database => "/tmp/123" }
  end

  let(:record1) do
    SimpleModel.new.tap do |r|
      r.field = "field"
      r.save
    end
  end

  let(:record2) { record1 }

  let(:record3) do
    SimpleModel.new.tap do |r|
      r.field = "field2"
      r.save
    end
  end

  let(:record4) { "other object" }

  it "should compare records according to its class and sorm id" do
    record1.should     == record2
    record1.should_not == record3
    record1.should_not == record4
  end

end