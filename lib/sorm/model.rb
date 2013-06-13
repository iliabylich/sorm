class SORM::Model
end

require 'sorm/model/attributes'
require 'sorm/model/persistence'
require 'sorm/model/comparison'
require 'sorm/model/initialization'
require 'sorm/model/inspection'
require 'sorm/model/duplication'
require 'sorm/model/api'
require 'sorm/model/validation'

[
  SORM::Model::Attributes,
  SORM::Model::Persistence,
  SORM::Model::Comparison,
  SORM::Model::Initialization,
  SORM::Model::Inspection,
  SORM::Model::Duplication,
  SORM::Model::API,
  SORM::Model::Validation
].each do |mod|
  SORM::Model.send(:include, mod)
end

