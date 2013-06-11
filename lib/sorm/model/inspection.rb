module SORM::Model::Inspection

  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  module ClassMethods

    def inspect
      "#{self.name} <[ #{extended_attributes.map(&:to_s).map{|a| ":#{a}" }.join(", ")} ]>"
    end

  end

  def to_s
    klass = self.class
    %Q{#<#{klass}:instance #{klass.send(:extended_attributes).map { |attr_name| "@#{attr_name}=\"#{send(attr_name)}\"" }.join(", ") }>}
  end

end