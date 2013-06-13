require 'spec_helper'

describe SORM::Model::Utils do

  it "#create" do
    r = SimpleModel.create(field: "value")
    SimpleModel.all.count.should eq 1
    SimpleModel.first.should eq r
  end

  it "#count" do
    5.times { SimpleModel.create(field: "value") }
    SimpleModel.count.should eq 5
  end

end