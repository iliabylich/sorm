require 'spec_helper'

describe SORM::Storage do

  let(:config) do
    { database: "/tmp/sdbm-orm.storage" }
  end

  subject(:storage) { SORM::Storage.new(config) }

  before do
    storage.clear
  end

  after do
    SORM::Storage.clear_hooks
  end

  it "#initialize" do
    storage.config.should eq config
  end

  it "#get" do
    storage.set("key", "value").should eq "value"
  end

  it "#set" do
    storage.set("key", "value")
    storage.get("key").should eq "value"
  end

  it "#keys" do
    storage.keys.should eq []
    storage.set("key", "value")
    storage.keys.should eq ["key"]
  end

  it "#[]" do
    storage.set("key", "value")
    storage["key"].should eq "value"
  end

  it "#[]=" do
    storage["key"] = "value"
    storage["key"].should eq "value"
  end

  it "#clear" do
    storage["key"] = "value"
    storage.clear
    storage["key"].should eq nil
    storage.keys.should eq []
  end

  context "hooks" do

    let(:hook_object) { stub(:HookObject).as_null_object }
    let(:fake_sdbm) { stub(:FakeSDBM) }

    it "stores hooks" do
      SORM::Storage.add_hook_object(hook_object)
      SORM::Storage.hook_objects.should eq [hook_object]
    end

    context "call hooks" do

      before do
        SORM::Storage.add_hook_object(hook_object)
        SDBM.stub(open: fake_sdbm)
      end

      it "#before_initialize" do
        hook_object.should_receive(:before_initialize).with(config)
        SORM::Storage.new(config)
      end

      it "#after_initialize" do
        hook_object.should_receive(:after_initialize).with(fake_sdbm)
        SORM::Storage.new(config)
      end

      it "#before_get" do
        hook_object.should_receive(:before_get).with("key")
        storage.get("key")
      end

      it "#after_get" do
        storage["key"] = "value"
        hook_object.should_receive(:after_get).with("key", "value")
        storage["key"]
      end

      it "#before_set" do
        hook_object.should_receive(:before_set).with("key", "value")
        storage["key"] = "value"
      end

      it "#after_set" do
        hook_object.should_receive(:after_set).with("key", "value")
        storage["key"] = "value"
      end

      it "#before_clear" do
        hook_object.should_receive(:before_clear).with(no_args)
        storage.clear
      end

      it "#after_clear" do
        hook_object.should_receive(:after_clear).with(no_args)
        storage.clear
      end

    end

  end

end