class Company < SORM::Model

  attribute :name

  validate :name, presence: true

end