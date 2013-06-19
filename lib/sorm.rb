require 'securerandom'
require 'json/ext'
require 'pry'

# SORM is a zero-dependency ORM
#
module SORM

  # @private
  #
  VERSION = "1.0.0"

end

require 'sorm/configuration'
require 'sorm/model'
require 'sorm/storage'
require 'sorm/exceptions'
