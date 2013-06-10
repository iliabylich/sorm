require 'sorm/models/attributes'
require 'sorm/models/persistence'
require 'sorm/models/comparison'

module SORM
  class Model

    include SORM::Models::Attributes
    include SORM::Models::Persistence
    include SORM::Models::Comparison

  end
end