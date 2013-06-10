require 'sorm/models/attributes'
require 'sorm/models/persistence'

module SORM
  class Model

    include SORM::Models::Attributes
    include SORM::Models::Persistence

  end
end