require 'spec_helper'

describe SORM::Model::Inspection do

  before do
    SORM.storage_config = { database: "/tmp/db" }
  end

  let(:new_record) { SimpleModel.new(field: "value") }

  let(:saved_record) do
    r = new_record.dup
    r.save
    r
  end

  context "class" do
    it "should inspect class" do
      SimpleModel.inspect.should eq %Q{SimpleModel <[ :field, :sorm_id ]>}
    end
  end

  context "instance" do
    it "should inspect new record (without id)" do
      new_record.inspect.should eq %Q{#<SimpleModel:instance @field="value", @sorm_id="">}
    end

    it "should inspect saved record (with id)" do
      saved_record.stub(sorm_id: "sorm-id")
      saved_record.inspect.should eq %Q{#<SimpleModel:instance @field="value", @sorm_id="sorm-id">}
    end
  end

end