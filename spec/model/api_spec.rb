require 'spec_helper'

describe SORM::Model::API do

  let(:record) { SimpleModel.new(field: "value") }

  before { record.save }

  it "#first" do
    SimpleModel.first.should eq record
  end

  it "#find" do
    SimpleModel.find(record.sorm_id).should eq record
    SimpleModel.find("non-existing-id").should eq nil
  end

  it "#where" do
    SimpleModel.create(field: "asd")
    SimpleModel.where(field: "value").count.should eq 1
    SimpleModel.where(field: "value").first.should eq record
  end

  it "#create" do
    SimpleModel.all.count.should eq 1
    SimpleModel.first.should eq record
  end

  it "#count" do
    SimpleModel.count.should eq 1
  end

  it "#update" do
    record.update(field: "value2")
    record.field.should eq "value2"
    SimpleModel.where(field: "value2").should eq [record]
  end



end