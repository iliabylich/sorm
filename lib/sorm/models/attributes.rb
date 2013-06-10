module SORM
  module Models

    # This module contains base methods for attribute definition
    #
    module Attributes

      # Included hook for adding self-methods
      #
      def self.included(klass)
        klass.send(:extend, ClassMethods)
      end

      # Module with class methods
      #
      module ClassMethods

        # Returns list of attributes
        #
        # @return [Array<Symbol>]
        #
        def attributes
          @attributes ||= [:sorm_id]
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
        end

        private

        # @private
        #
        def add_attribute(attr_name, options)
          send(:attr_accessor, attr_name)

          define_method attr_name do
            instance_variable_get("@#{attr_name}") || options[:default]
          end
        end

      end

      # Returns list of attributes
      #
      # @return [Array<Symbol>]
      #
      def attributes
        self.class.attributes
      end

    end
  end
end
