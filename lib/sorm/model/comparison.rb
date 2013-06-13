# Module with compare method
#
module SORM::Model::Comparison

  # Compare method
  #
  # @param other [Object]
  #
  def ==(other)
    other.instance_of?(self.class) and self.sorm_id == other.sorm_id
  end

  alias :eql? ==

end