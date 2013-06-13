module SORM::Model::Validation

  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  def valid?
    false
  end

  module ClassMethods

    def validations
      @_validations ||= []
    end

    def validate(field, options, &block)
      validations << [field, options, block]
    end

  end

end