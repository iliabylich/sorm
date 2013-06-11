require 'sorm/models/attributes'
require 'sorm/models/persistence'
require 'sorm/models/comparison'
require 'sorm/models/initialization'

module SORM
  class Model

    include SORM::Models::Attributes
    include SORM::Models::Persistence
    include SORM::Models::Comparison
    include SORM::Models::Initialization

  end
end