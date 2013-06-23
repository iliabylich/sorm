# Base module for type dcasting
#
module SORM::Model::TypeCasting

  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  # Module with TypCasting class-methods
  #
  module ClassMethods

    # Method for defining type casting for specified attribute
    #
    # @param attribute_name [Symbol] name of attribute
    # @param options [Hash]
    # @option options [Class] :to class that we need type cast to
    # @option options [Symbol, String] :with method name that should be performed for type casting
    #
    # @example :to example
    #   class User < SORM::Model
    #     attribute :name
    #     cast :name, to: Fixnum
    #   end
    #
    #   User.new(name: "123").name
    #   # => 123
    #
    # @example :with example
    #   class User < SORM::Model
    #     attribute :name
    #     cast :name, with: "to_i"
    #   end
    #
    #   User.new(name: "123").name
    #   # => 123
    #
    def cast(attribute_name, options = {})
      if options[:to]
        define_direct_casting attribute_name, options[:to]
      elsif options[:with]
        define_method_casting attribute_name, options[:with]
      end
    end


    private

    # Constant for mapping { Class => "method for type casting" }
    #
    DIRECT_CASTING_MAPPING = {
      Fixnum => :to_i,
      String => :to_s,
      JSON   => :to_json,
      Object => :to_object, # Blank casting
    }

    def define_direct_casting(attribute_name, klass)
      alias_method "old_#{attribute_name}", attribute_name

      type_cast_method = DIRECT_CASTING_MAPPING[klass]

      define_method attribute_name do
        send("old_#{attribute_name}").send(type_cast_method)
      end
    end

    def define_method_casting(attribute_name, method_name)
      alias_method "old_#{attribute_name}", attribute_name

      define_method attribute_name do
        send("old_#{attribute_name}").send(method_name)
      end
    end

  end

end