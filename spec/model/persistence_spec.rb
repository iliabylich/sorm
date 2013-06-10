require 'spec_helper'

describe SORM::Models::Persistence do

  subject(:record) { SimpleModel.new }
  let(:generated_id) { "generatedID" }

  before do
    UUID.stub(:generate => generated_id)
  end


  it "#sorm_id" do
    record.sorm_id.should eq generated_id
  end

  it "#sorm_attributes" do
    record.field = "value"
    expected_result = {
      :field => "value",
      :sorm_id => "generatedID"
    }
    record.sorm_attributes.should eq expected_result
  end

  context "store" do

    before do
      SORM.configure do |config|
        config.storage_config = { :database => "/tmp/db" }
      end
      SORM.storage.clear

    end

    let!(:saved_record) do
      record.field = "value"
      record.save
      record
    end

    it "should fetch records" do
      SimpleModel.all.count.should eq 1
    end

    it "should find record" do
      record = SimpleModel.all.first
      record.field.should   eq saved_record.field
      record.sorm_id.should eq saved_record.sorm_id
    end

    it "should find a model" do
      record = SimpleModel.find(saved_record.sorm_id)
      record.field.should   eq saved_record.field
      record.sorm_id.should eq saved_record.sorm_id
    end
  end




end