class Person < SDBM::ORM::Model

  attribute :first_name
  attribute :last_name

  attribute :default_name, :default => "default name"

end