module SORM::Model::Utils

  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  module ClassMethods

    def create(options = {})
      new(options).tap(&:save)
    end

    def count
      all.count
    end

  end

end