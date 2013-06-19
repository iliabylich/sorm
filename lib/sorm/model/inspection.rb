# Module with #inspect and #to_s methods
#
module SORM::Model::Inspection

  # @private
  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  # Ispection class-methods
  #
  module ClassMethods

    # @example
    #   record = Model.new(name: "Gena")
    #
    #   puts record
    #   # => "Model <[ :name, :sorm_id ]>"
    def to_s
      "#{self.name} <[ #{extended_attributes.map(&:to_s).map{|a| ":#{a}" }.join(", ")} ]>"
    end

    alias :inspect :to_s
    alias :to_str :to_s

  end

  # @example
  #   record = Model.new(name: "Gena")
  #
  #   puts record
  #   # => #<Model:instance @name="Gena", @sorm_id="">
  #
  def to_s
    klass = self.class
    %Q{#<#{klass.name}:instance #{send(:extended_attributes).map { |attr_name| "@#{attr_name}=\"#{send(attr_name)}\"" }.join(", ") }>}
  end

  alias :inspect :to_s
  alias :to_str :to_s

end