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
    Person.new(first_name: "fname").first_name.should eq "fname"
  end


  context "#default_name" do
    it "should return default attributes" do
      person.default_name.should eq "default name"
    end

    it "should return stored value instead of overriden if it present" do
      Person.new(default_name: "default name 2").default_name.should eq "default name 2"
    end
  end

  it "#extended_attributes" do
    Person.new.extended_attributes.should eq [:first_name, :last_name, :default_name, :sorm_id]
  end

  it "#attributes_list" do
    expected_data = { first_name: "name", last_name: nil, default_name: "default name", sorm_id: nil }
    Person.new(first_name: "name").attributes_list.should eq expected_data
  end

end