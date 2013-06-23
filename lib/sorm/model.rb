# Model class
#
# @example Usage:
#   class MyModel < SORM::Model
#   end
#
# @see SORM::Model::Attributes Attributes - methods for attributes definition
# @see SORM::Model::Persistence Persistence - base methods for storing, destroying, updating and finding
# @see SORM::Model::Comparison Comparison - methods for comparing records
# @see SORM::Model::Initialization Initialization - methods for record initialization
# @see SORM::Model::Inspection Inspection - methods for records displaying
# @see SORM::Model::Duplication Duplication - methods for record duplication
# @see SORM::Model::API API - main API module. has methods like create, find, where etc
# @see SORM::Model::Validation Validation - validation module
# @see SORM::Model::Association Association - association module
# @see SORM::Model::TypeCasting TypeCasting - type casting module
#
class SORM::Model
end

require 'sorm/model/hooks'
require 'sorm/model/attributes'
require 'sorm/model/persistence'
require 'sorm/model/comparison'
require 'sorm/model/initialization'
require 'sorm/model/inspection'
require 'sorm/model/duplication'
require 'sorm/model/api'
require 'sorm/model/validation'
require 'sorm/model/association'
require 'sorm/model/type_casting'

[
  SORM::Model::Hooks,
  SORM::Model::Attributes,
  SORM::Model::Persistence,
  SORM::Model::Comparison,
  SORM::Model::Initialization,
  SORM::Model::Inspection,
  SORM::Model::Duplication,
  SORM::Model::API,
  SORM::Model::Validation,
  SORM::Model::Association,
  SORM::Model::TypeCasting,
].each do |mod|
  SORM::Model.send(:include, mod)
end

