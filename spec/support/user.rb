class Profile < SORM::Model
  attribute :full_name
  belongs_to :user, :class => "User"
  belongs_to :admin, :class => "Admin"
end

class User < SORM::Model
  attribute :email
  has_one :profile, :class => "Profile"
end

class Admin < SORM::Model
  attribute :email
  has_many :profiles, :class => "Profile"
end