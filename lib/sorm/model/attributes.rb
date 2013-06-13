# This module contains base methods for attribute definition
#
module SORM::Model::Attributes

  # Included hook for adding self-methods
  #
  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  def attribute(attr_name)
    send(attr_name)
  end

  # Module with class methods
  #
  module ClassMethods

    # Returns list of attributes
    #
    # @return [Array<Symbol>]
    #
    def attributes
      @attributes ||= []
    end

    # Method for defining attribute
    #
    # Defines get and set methods
    #
    # @param attr_name [Symbol] name of attribute
    # @param options [Hash]
    # @option options [Object] :default
    #
    def attribute(attr_name, options = {})
      attributes << attr_name
      add_attribute(attr_name, options)
      self
    end

    protected

    # @private
    #
    def add_attribute(attr_name, options)
      define_method "#{attr_name}=" do |value|
        instance_variable_set("@#{attr_name}", value)
      end

      define_method attr_name do
        instance_variable_get("@#{attr_name}") || options[:default]
      end
    end

    def extended_attributes
      attributes + [:sorm_id]
    end

  end

  # Returns list of attributes
  #
  # @return [Array<Symbol>]
  #
  def attributes
    self.class.attributes
  end

  def extended_attributes
    self.class.send(:extended_attributes)
  end

  def attributes_list
    Hash[extended_attributes.map { |attr_name| [attr_name, send(attr_name)] }]
  end

end
