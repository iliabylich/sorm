class ModelWithHooks < SORM::Model

  attribute :state

  def mark_as(new_state)
    self.state = new_state
  end

end