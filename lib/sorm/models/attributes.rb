module SORM
  module Models
    module Attributes

      def self.included(klass)
        klass.send(:extend, ClassMethods)
        klass.send(:include, InstanceMethods)
      end

      module ClassMethods

        def attributes
          @attributes ||= [:sorm_id]
        end

        def attribute(attr_name, options = {})
          attributes << attr_name
          add_attribute(attr_name, options)
        end

        def add_attribute(attr_name, options)
          default_value = options[:default]

          define_method attr_name do
            instance_variable_get("@#{attr_name}") || default_value
          end

          define_method "#{attr_name}=" do |value|
            instance_variable_set("@#{attr_name}", value)
          end
        end

      end

      module InstanceMethods

        def attributes
          self.class.attributes
        end

      end

    end
  end
end
