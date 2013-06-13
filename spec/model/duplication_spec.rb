require 'spec_helper'

describe SORM::Model::Duplication do

  subject(:model) { SimpleModel.new(field: "value").tap(&:save) }
  let(:duplicate) { model.dup }

  it "should duplicate all fields except of sorm_id" do
    duplicate = model.dup
    duplicate.field.should eq "value"
    duplicate.sorm_id.should eq nil
  end

end