require 'spec_helper'

describe SORM::CLI do

  subject(:cli) { SORM::CLI }

  it "should display help" do
    cli.any_instance.should_receive(:run_help).with(no_args)
    cli.run("--help")
  end

  context "#template" do
    it "should create template from blank model" do
      cli.new("create", "User").template.should eq "class User < SORM::Model\nend\n"
    end

    it "should create template from model with attributes" do
      cli.new("create", "User", "email").template.should eq "class User < SORM::Model\n  attribute :email\nend\n"
    end
  end

  it "#filename" do
    cli.new("create", "User").filename.should eq "user.rb"
    cli.new("create", "AdminUser").filename.should eq "admin_user.rb"
  end

  context "create file" do

    let(:filename) { "user.rb" }

    around(:each) do |e|
      FileUtils.rm_rf(filename)
      e.call
      FileUtils.rm_rf(filename)
    end

    it "should put the file in current dir" do
      cli.run("create", "User")
      File.exist?(File.join GEM_ROOT, "user.rb").should be_true
    end

  end

end
