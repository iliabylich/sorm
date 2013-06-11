require 'spec_helper'

describe SORM::Models::Persistence do

  subject(:record) { SimpleModel.new }
  let(:generated_id) { "generatedID" }

  before do
    UUID.stub(generate: generated_id)
    SORM.storage_config = { database: "/tmp/db" }
    SORM.storage.clear
  end

  it "#sorm_id" do
    record.sorm_id.should eq nil
    record.save
    record.sorm_id.should eq generated_id
  end

  context "store" do

    before do
      record.field = "value"
      record.save
    end

    let(:saved_record) { SimpleModel.where(field: "value").first }

    it "#all" do
      SimpleModel.all.should eq [saved_record]
    end

    it "#first" do
      SimpleModel.first.should eq saved_record
    end

    it "#find" do
      SimpleModel.find(saved_record.sorm_id).should eq saved_record
    end

    it "#where" do
      SimpleModel.where(field: "value").first.should eq saved_record
    end

    context "persisted" do

      it "should be persisted if stored in db" do
        record.persisted?.should eq true
      end

      it "should not be persisted if not stored in db" do
        SimpleModel.new.persisted?.should eq false
      end

    end

  end




end