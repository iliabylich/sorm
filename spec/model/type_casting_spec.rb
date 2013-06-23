require 'spec_helper'

Fixnum.send(:define_method, :to_five) { 5 }

describe SORM::Model::TypeCasting do

  let(:cast_klass) { ModelWithTypeCasting }

  before do
    cast_klass.create(count: "10", some_object: 123, five: 123, number: 1)
  end

  let(:record) { cast_klass.first }

  context "direct casting" do
    it "should type cast attribute to class if it respond to type cast method" do
      record.count.should eq 10
    end
  end

  context "using specified method" do
    it "should be able to pass convert method" do
      record.five.should eq 5
    end
  end

end