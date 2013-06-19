require 'securerandom'
require 'json/ext'
require 'pry'

# SORM is a zero-dependency ORM
#
module SORM

  # @private
  #
  VERSION = "0.0.1"

end

require 'sorm/configuration'
require 'sorm/model'
require 'sorm/storage'
require 'sorm/exceptions'
