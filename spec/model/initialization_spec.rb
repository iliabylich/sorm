require 'spec_helper'

describe SORM::Model::Initialization do

  it "should be able to build blank object passing blank hash" do
    r = SimpleModel.new
    r.field.should be_nil
  end

  it "should be able to build object passing hash" do
    r = SimpleModel.new(field: "value")
    r.field.should eq "value"
  end

end