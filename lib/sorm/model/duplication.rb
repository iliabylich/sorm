# Module with #dup method
#
module SORM::Model::Duplication

  # Returns new record with same attribute values (except of sorm_id)
  #
  # If you need to copy all record (with sorm_id), use #clone
  #
  # @return [Object] copy of current record
  #
  # @example
  #   class Model < SORM::Model
  #     attribute :name
  #   end
  #
  #   record = Model.new(name: "Gena")
  #   # => #<Model @name="Gena", @sorm_id="generated-id">
  #
  #   record.dup
  #   # => #<Model @name="Gena", @sorm_id=nil>
  #
  def dup
    self.class.new(attributes_list_without_sorm_id)
  end

  private

  def attributes_list_without_sorm_id
    attributes_list.tap { |h| h.delete(:sorm_id) }
  end

end