# This module contains base methods for attribute definition
#
module SORM::Model::Attributes

  # @private
  #
  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  # Returns value of passed attribute name
  #
  # @param attr_name [Symbol] name of attribute
  #
  # @return [Object] value of attribute
  #
  # @example
  #   class Model < SORM::Model
  #     attribute :name
  #   end
  #
  #   record = Model.new(name: "Gena")
  #   # => #<Model @name="Gena">
  #
  #   record.attribute(:name)
  #   # => "Gena"
  #
  def attribute(attr_name)
    send(attr_name)
  end

  # Module with Attributes class methods
  #
  module ClassMethods

    # Returns list of attributes
    #
    # @return [Array<Symbol>]
    #
    # @example
    #   class Model < SORM::Model
    #     attribute :name
    #   end
    #
    #   Model.attributes
    #   # => [:name]
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
    # @example
    #   class Model < SORM::Model
    #     attribute :name
    #   end
    #
    def attribute(attr_name, options = {})
      attributes << attr_name
      add_attribute(attr_name, options)
      self
    end

    protected

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

  # Returns list of attributes (simply delegates if to class)
  #
  # @return [Array<Symbol>]
  #
  def attributes
    self.class.attributes
  end

  # Returns hash representation of record
  #
  # @return [Hash] hash of attributes
  #
  # @example
  #   class Model < SORM::Model
  #     attribute :name
  #   end
  #
  #   record = Model.new(name: "Gena")
  #   # => #<Model @name="Gena" @sorm_id=nil>
  #
  #   record.attributes_list
  #   # => { name: "Gena", sorm_id: nil }
  #
  #   record.save
  #   # => true
  #
  #   record.attributes_list
  #   # => { name: "Gena", sorm_id: "some-generated-id" }
  #
  def attributes_list
    Hash[extended_attributes.map { |attr_name| [attr_name, send(attr_name)] }]
  end

  alias :to_h :attributes_list

  protected

  def extended_attributes
    self.class.send(:extended_attributes)
  end

end
