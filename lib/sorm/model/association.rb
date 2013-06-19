# This module contains base association methods
# #has_one, #has_many, #belongs_to
#
module SORM::Model::Association

  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  # Module with Association class-methods
  #
  module ClassMethods

    # Defines one-to-one association
    #
    # @param association_name [String] name of association (and method)
    # @param options [Hash]
    # @option options [String] :class class we want to connect
    #
    # @example Usage:
    #   class Profile < SORM::Model
    #     belongs_to :user, class: "User"
    #   end
    #   class User < SORM::Model
    #     has_one :profile, class: "Profile"
    #   end
    #
    #   User.new.profile
    #   # => nil
    #
    #   user    = User.create
    #   profile = Profile.create(user_id: user.sorm_id)
    #
    #   user.profile
    #   # => #<Profile:instance @sorm_id="some-generated-id">
    #
    # @see #belongs_to
    #
    def has_one(association_name, options)
      define_method association_name do
        klass = SORM::Model.fetch_subclass_by_name(options[:class])
        attribute = self.class.name.downcase + "_id"
        klass.where(attribute => self.sorm_id).first
      end
    end

    # Defines one-to-many association
    #
    # @param association_name [String] name of association (and method)
    # @param options [Hash]
    # @option options [String] :class class we want to connect
    #
    # @example Usage:
    #   class Profile < SORM::Model
    #     belongs_to :user, class: "User"
    #   end
    #   class User < SORM::Model
    #     has_many :profiles, class: "Profile"
    #   end
    #
    #   User.new.profiles
    #   # => []
    #
    #   user = User.create
    #   profile1 = Profile.create(user_id: user.sorm_id)
    #   profile2 = Profile.create(user_id: user.sorm_id)
    #
    #   user.profiles
    #   # => [#<Profile:instance @sorm_id="some-id-1">, #<Profile:instance @sorm_id="some-id-2">]
    #
    # @see #belongs_to
    #
    def has_many(association_name, options)
      define_method association_name do
        klass = SORM::Model.fetch_subclass_by_name(options[:class])
        attribute = self.class.name.downcase + "_id"
        klass.where(attribute => self.sorm_id)
      end
    end

    # Support for one-to-one and one-to-many association
    # Defines attribute for association
    #
    # @param association_name [String] name of association (and method)
    # @param options [Hash]
    # @option options [String] :class class we want to connect
    #
    # @example Usage:
    #   class User < SORM::Model
    #     has_one :profile, class: "Profile"
    #   end
    #   class Company < SORM::Model
    #     has_many :profiles, class: "Profile"
    #   end
    #   class Profile < SORM::Model
    #     belongs_to :user, class: "User"
    #     belongs_to :company, class: "Company"
    #   end
    #
    #   Profile.attributes
    #   # => [:user_id]
    #
    #   Profile.new.user
    #   # => nil
    #   Profile.new.company
    #   # => nil
    #
    #   user = User.create
    #   company = Company.create
    #   profile = Profile.create(user_id: user.sorm_id, company_id: company.sorm_id)
    #
    #   profile.user
    #   # => #<User:instance @sorm_id="generated-id">
    #
    #   profile.company
    #   # => #<Company:instance @sorm_id="generated-id">
    #
    # @see #has_one
    # @see #has_many
    #
    # @example Validation on association:
    #   class Profile < SORM::Model
    #     belongs_to :user, class: "User"
    #     validate :user_id, presence: true
    #   end
    #
    def belongs_to(association_name, options)
      attribute_name = options[:class].downcase + "_id"
      attribute attribute_name

      define_method association_name do
        klass = SORM::Model.fetch_subclass_by_name(options[:class])
        klass.where(:sorm_id => attribute(attribute_name)).first
      end
    end

    # @private
    #
    def inherited(klass)
      subclasses[klass.name] = klass
      super
    end

    # @private
    #
    def subclasses
      @@subclasses ||= {}
    end

    # @private
    #
    def fetch_subclass_by_name(klass_name)
      SORM::Model.subclasses[klass_name]
    end

  end

end