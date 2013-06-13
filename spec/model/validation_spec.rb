require 'spec_helper'

# class Company < SORM::Model
#
#   attribute :name
#   attribute :state
#   attribute :owner
#
#   validate :state, presence: true
#   validate :name, uniq: true
#   validate :owner do |record|
#     record.owner == "Ilya"
#   end
#
# end

describe SORM::Model::Validation do

  context "#presence" do

    let(:company) { Company.new(name: "company 1", owner: "Ilya") }

    it "#valid?" do
      expect(company.valid?).to be_false
    end

    it "#errors" do
      company.errors.length.should eq 1
      company.errors.first.should eq [:state, "Can't be blank"]
    end
  end

  context "#uniq" do

    before { Company.create(name: "company 2", owner: "Ilya", state: "state") }
    let(:company) { Company.new(name: "company 2", owner: "Ilya", state: "state") }

    it "#valid?" do
      expect(company.valid?).to be_false
    end

    it "#errors" do
      company.errors.length.should eq 1
      company.errors.first.should eq [:name, "Should be uniq"]
    end
  end

  context "#validation block" do

    let(:company) { Company.new(name: "company 3", owner: "Dave", state: "state") }

    it "#valid?" do
      expect(company.valid?).to be_false
    end

    it "#errors" do
      company.errors.length.should eq 1
      company.errors.first.should eq [:owner, "Validation block returns false-value"]
    end

  end

  context "#all errors :)" do

    let(:company) { Company.new(name: "company 2") }

    before do
      Company.create(name: "company 2", owner: "Ilya", state: "state")
    end

    it "#valid?" do
      expect(company.valid?).to be_false
    end

    it "#errors" do
      company.errors.count.should eq 3
    end

  end

  context "prevent saving" do

    it "should not save record if it's invalid" do
      Company.create.should eq false
      Company.count.should eq 0
    end

  end

end