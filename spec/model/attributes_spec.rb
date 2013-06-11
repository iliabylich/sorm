require 'spec_helper'

describe SORM::Model::Attributes do

  subject(:person) { Person.new }

  it "should return list of attributes" do
    person.attributes.should eq [:first_name, :last_name, :default_name]
  end

  it "should return nil as default attribute" do
    person.first_name.should eq nil
    person.last_name.should eq nil
  end

  it "should store attributes" do
    person.first_name = "fname"
    person.first_name.should eq "fname"
  end


  context "#default_name" do
    it "should return default attributes" do
      person.default_name.should eq "default name"
    end

    it "should return stored value instead of overriden if it present" do
      person.default_name = "default name 2"
      person.default_name.should eq "default name 2"
    end
  end

end