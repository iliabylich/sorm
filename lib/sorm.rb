require 'pry'
require 'json'
require 'sorm/model'
require 'sorm/storage'

module SORM
  VERSION = "0.0.1"

  class << self

    attr_accessor :storage_config

    def configure
      yield self
    end

    def storage
      @storage ||= SORM::Storage.new(storage_config)
    end
  end

end
