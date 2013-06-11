require 'spec_helper'

describe "SORM::Configuration" do

  let(:storage_config) { { :database => "tmp/db" } }

  it "should be able to configure database path" do
    SORM.configure do |config|
      config.storage_config = storage_config
    end
    SORM.storage_config.should eq storage_config
  end

  it "should raise exception when accessing storage when storage configuration is blank" do
    SORM.storage_config = nil
    expect { SORM.storage }.to raise_error(SORM::NotConfigured)
  end

end