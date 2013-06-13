require 'spec_helper'

describe SORM::Model::Validation do

  it "should validate presense" do
    expect(Company.new.valid?).to be_false
  end

  it "should take validation block"

end