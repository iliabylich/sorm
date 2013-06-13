class Company < SORM::Model

  attribute :name
  attribute :state
  attribute :owner

  validate :state, presence: true
  validate :name, uniq: true
  validate :owner do |record|
    record.owner == "Ilya"
  end

end