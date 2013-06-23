class ModelWithTypeCasting < SORM::Model
  attribute :count
  cast :count, to: Fixnum

  attribute :five
  cast :five, with: "to_five"

end