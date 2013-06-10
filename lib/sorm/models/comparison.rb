module SORM
  module Models

    # Module with compare method
    #
    module Comparison

      # Compare method
      #
      # @param other [Object]
      #
      def ==(other)
        other.instance_of?(self.class) and self.sorm_id == other.sorm_id
      end

    end
  end
end