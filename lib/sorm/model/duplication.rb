module SORM::Model::Duplication

  def dup
    self.class.new(attributes_list_without_sorm_id)
  end

  private

  def attributes_list_without_sorm_id
    attributes_list.tap { |h| h.delete(:sorm_id) }
  end

end