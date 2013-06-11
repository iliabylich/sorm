module SORM::Configuration
  attr_accessor :storage_config

  def configure
    yield self
  end

  def storage
    @storage ||= SORM::Storage.new(storage_config)
  end

  def reset_configuration!
    @storage = nil
  end
end

SORM.send(:extend, SORM::Configuration)