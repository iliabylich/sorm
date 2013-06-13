module SORM::Model::Inspection

  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  module ClassMethods

    def to_s
      "#{self.name} <[ #{extended_attributes.map(&:to_s).map{|a| ":#{a}" }.join(", ")} ]>"
    end

    alias :inspect :to_s
    alias :to_str :to_s

  end

  def to_s
    klass = self.class
    %Q{#<#{klass.name}:instance #{klass.send(:extended_attributes).map { |attr_name| "@#{attr_name}=\"#{send(attr_name)}\"" }.join(", ") }>}
  end

  alias :inspect :to_s
  alias :to_str :to_s

end