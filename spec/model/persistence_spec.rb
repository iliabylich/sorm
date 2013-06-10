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

    it "should parse query" do
      record2 = SimpleModel.new
      record2.field = "value2"
      record2.sorm_id = "another-id"
      record2.save
      SimpleModel.where(:field => "value").first.should eq saved_record
      SimpleModel.where(:field => "value2").first.should eq record2
    end
  end




end