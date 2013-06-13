require 'sorm/model/error'

module SORM::Model::Validation

  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  def errors
    errors_builder.errors
  end

  def valid?
    errors_builder.valid?
  end

  module ClassMethods

    def validations
      @_validations ||= []
    end

    def validate(field, options = {}, &block)
      validations << [field, options, block]
    end

  end

  private

  def errors_builder
    SORM::Model::Error.new(self)
  end


end