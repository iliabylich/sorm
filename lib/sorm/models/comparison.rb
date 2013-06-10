module SORM
  module Models
    module Comparison

        def ==(other)
          other.instance_of?(self.class) and self.sorm_id == other.sorm_id
        end

    end
  end
end