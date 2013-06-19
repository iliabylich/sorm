require 'spec_helper'

describe SORM::Model::Association do

  let!(:user) { User.create(email: "gena@example.com") }
  let!(:profile) { Profile.create(full_name: "Gena Krokodil", user_id: user.sorm_id) }

  context "#has_one" do
    it "should define assiciation method" do
      User.new.should respond_to(:profile)
    end

    it "should fetch associated record" do
      user.profile.should eq profile
    end
  end

  context "#belongs_to" do
    it "should define attribute for association" do
      Profile.attributes.should include("user_id")
    end

    it "should fetch associated record" do
      profile.user.should eq user
    end
  end

  context "#has_many" do

    let!(:admin) { Admin.create(email: "admin@example.com")  }
    let!(:profiles) { Array.new(2) { |i| Profile.create(full_name: "Admin #{i}", admin_id: admin.sorm_id) } }

    it "should define association method" do
      Admin.new.should respond_to(:profiles)
    end

    it "should fetch records" do
      admin.profiles.should eq profiles
      profiles.each do |profile|
        profile.user.should be_nil
        profile.admin.should eq admin
      end
    end
  end

end