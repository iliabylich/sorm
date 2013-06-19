#
# Main configuration module
#
# @example Basic usage:
#   SORM.configure do |config|
#     config.storage_config = {
#       database: "/tmp/storage"
#     }
#   end
#
# @example Or easier:
#   SORM.storage_config = { database: "/tmp/storage" }
#
module SORM::Configuration

  # Returns config for data storage
  #
  attr_accessor :storage_config

  # Main configuration method
  #
  # @yield SORM
  #
  # @example
  #   SORM.configure do |config|
  #     config.storage_config = {
  #       database: "/tmp/storage"
  #     }
  #   end
  #
  def configure
    yield self
  end

  # Returns storage for configured file.
  #
  # @return [SORM::Storage]
  # @see SORM::Storage
  #
  def storage
    @storage ||= SORM::Storage.new(storage_config)
  end

  # Method for using blank configuration
  #
  # @example
  #   SORM.configure do |config|
  #     config.storage_config = {
  #       database: "/tmp/storage"
  #     }
  #   end
  #
  #   SORM.storage_config
  #   # => { database: "/tmp/storage" }
  #
  #   SORM.reset_configuration!
  #   # => nil
  #
  #   SORM.storage_config
  #   # => nil
  #
  def reset_configuration!
    @storage_config = nil
    @storage = nil
  end
end

SORM.send(:extend, SORM::Configuration)