require 'spec_helper'

describe SORM::Model::Persistence do

  subject(:record) { SimpleModel.new(field: "value") }
  let(:generated_id) { "generatedID" }

  before do
    SecureRandom.stub(uuid: generated_id)
  end

  it "#sorm_id" do
    record.sorm_id.should eq nil
    record.save
    record.sorm_id.should eq generated_id
  end

  context "store" do

    let(:saved_record) { record.tap(&:save) }

    context "persisted" do

      it "should be persisted if stored in db" do
        saved_record.persisted?.should eq true
      end

      it "should not be persisted if not stored in db" do
        SimpleModel.new.persisted?.should eq false
      end

    end

    context "#save" do

      it "should record to storage" do
        record.save
        SimpleModel.all.should eq [record]
      end

      it "should not save if it's persisted (already in db)" do
        record.stub(:persisted? => true)
        record.save
        SimpleModel.all.should eq []
      end

      it "should set persisted = true" do
        record.save
        expect(record.persisted?).to be_true
      end

    end

    context "#all" do

      it "should return all records" do
        record.save
        SimpleModel.all.should eq [record]
      end

      it "should return blank array if we have no records" do
        SimpleModel.all.should eq []
      end

    end

    context "#delete" do

      it "should delete record" do
        saved_record.delete
        SimpleModel.all.should eq []
      end

      it "should set persisted = false" do
        expect(saved_record.tap(&:delete).persisted?).to be_false
      end

      it "should set flush sorm_id" do
        saved_record.tap(&:delete).sorm_id.should be_false
      end

    end


  end




end