class SORM::Model
end

require 'sorm/model/attributes'
require 'sorm/model/persistence'
require 'sorm/model/comparison'
require 'sorm/model/initialization'
require 'sorm/model/inspection'

[
  SORM::Model::Attributes,
  SORM::Model::Persistence,
  SORM::Model::Comparison,
  SORM::Model::Initialization,
  SORM::Model::Inspection
].each do |mod|
  SORM::Model.send(:include, mod)
end

