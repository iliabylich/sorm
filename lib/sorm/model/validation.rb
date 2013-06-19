require 'sorm/model/error'

# Module with validation methods
#
module SORM::Model::Validation

  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  # Returns errors of record (after validation)
  #
  # @return [Hash] hash with errors in format { attribute => "error message" }
  #
  # @example
  #   class Model < SORM::Model
  #   end
  #
  # @see SORM::Model::Error#errors
  #
  def errors
    errors_builder.errors
  end

  # Returns true if object is valid
  #
  # @return [true, false]
  #
  # @see SORM::Model:::Error#valid?
  #
  def valid?
    errors_builder.valid?
  end

  # Module with Validation class-methods
  #
  module ClassMethods

    # Returns all validation
    #
    # @return [Array<Array>] format is [field, options, block]
    #
    def validations
      @_validations ||= []
    end

    # Sets validation for specified field
    #
    # @param field [Symbol] name of field
    # @param options [Hash] hash with options
    # @yield instance
    #
    # @example Usage:
    #   class Model < SORM::Model
    #     attribute :name
    #     validate :name, some: options
    #   end
    #
    # @example Presence validation:
    #   class Model < SORM::Model
    #     attribute :name
    #     validate :name, presence: true
    #   end
    #
    # @example Uniq validation
    #   class Model < SORM::Model
    #     attribute :name
    #     validate :name, uniq: true
    #   end
    #
    # @example Validation block:
    #   class Model < SORM::Model
    #     attribute :name
    #     validate :name do |record|
    #       record.name =~ "Gena"
    #     end
    #   end
    #
    def validate(field, options = {}, &block)
      validations << [field, options, block]
    end

  end

  private

  def errors_builder
    SORM::Model::Error.new(self)
  end


end