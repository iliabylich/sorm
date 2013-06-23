require "spec_helper"

describe SORM::Model::Hooks do

  before do
    ModelWithHooks.clear_registered_hooks
  end

  context "#initialize" do
    it "#after" do
      ModelWithHooks.after(:initialize) { mark_as "after_initialize" }
      ModelWithHooks.new.state.should eq "after_initialize"
    end
  end

  context "#save" do
    it "#before" do
      ModelWithHooks.before(:save) { mark_as "before_save" }
      ModelWithHooks.create.state.should eq "before_save"
    end

    it "#after" do
      ModelWithHooks.after(:save) { mark_as "after_save" }
      ModelWithHooks.create.state.should eq "after_save"
    end
  end

  context "#update" do
    let(:created_record) { ModelWithHooks.create }

    it "#before" do
      ModelWithHooks.before(:update) { mark_as "before_update" }
      created_record.update
      created_record.state.should eq "before_update"
    end

    it "#after" do
      ModelWithHooks.after(:update) { mark_as "after_update" }
      created_record.update
      created_record.state.should eq "after_update"
    end
  end

  context "#delete" do
    let(:created_record) { ModelWithHooks.create }

    it "#before" do
      ModelWithHooks.before(:delete) { mark_as "before_delete" }
      created_record.delete
      created_record.state.should eq "before_delete"
    end

    it "#after" do
      ModelWithHooks.after(:delete) { mark_as "after_delete" }
      created_record.delete
      created_record.state.should eq "after_delete"
    end
  end

  context "#raising error" do
    it "should raise error if block is not passed" do
      expect { ModelWithHooks.after(:save) }.to raise_error SORM::NoBlockGiven
    end

    it "should raise error for unknown hook type" do
      expect { ModelWithHooks.before(:some_hook) {} }.to raise_error SORM::UnknowHook
    end
  end
end