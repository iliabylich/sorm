# Module with base methods for hooks definition
#
module SORM::Model::Hooks

  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  # Module with Hook class-methods
  #
  module ClassMethods

    # Method for defining before-action hook
    #
    # @param action [Symbol] type of hook
    # @yield self
    # @raise [SORM::NoBlockGiven] when no block given
    # @raise [SORM::UnknowHook] when hook is not predefined
    # @see HOOKS
    # @see #after
    #
    # @example before initialize example:
    #   class User < SORM::Model
    #     attribute :email
    #
    #     after :initialize do
    #       self.email = "email"
    #     end
    #   end
    #
    #   User.new.email
    #   # => "email"
    #
    # @example after save example:
    #   class User < SORM::Model
    #     attribute :email
    #
    #     after :save do
    #       puts "Saved with email = #{email}"
    #     end
    #   end
    #
    #   User.create(email: "email@example.com")
    #   # => Saved with email = email@example.com
    #
    # @example before update example:
    #   class Admin < SORM::Model
    #     attribute :password
    #
    #     before :update do
    #       raise "Can't override password for admin-user"
    #     end
    #   end
    #
    # @example after delete example:
    #   class SomeRelation < SORM::Model
    #     belongs_to :subj1
    #     belongs_to :subj2
    #
    #     before :delete do
    #       NotificationMailer.notify("Removed relation between subj1 #{self.subj1_id} and subj2 #{self.subj2_id}")
    #     end
    #   end
    #
    def before(action, &block)
      raise SORM::NoBlockGiven, "You should pass a block to #before hook" unless block_given?
      register_hook(:before, action, &block)
    end

    # Method for defining after-action hook
    #
    # @param action [Symbol] type of hook
    # @yield self
    # @raise [SORM::NoBlockGiven] when no block given
    # @raise [SORM::UnknowHook] when hook is not predefined
    # @see HOOKS
    # @see #before
    #
    def after(action, &block)
      raise SORM::NoBlockGiven, "You should pass a block to #after hook" unless block_given?
      register_hook(:after, action, &block)
    end

    # Method for clearing all before/after hooks
    #
    def clear_registered_hooks
      @registered_hooks = nil
    end

    # All available hooks
    #
    HOOKS = {
      before: [:save, :update, :delete],
      after:  [:initialize, :save, :update, :delete]
    }

    private

    def register_hook(hook_type, action, &block)
      unless check_hook(hook_type, action)
        raise SORM::UnknowHook, "Unknown hook #{hook_type} #{action}"
      end
      hooks_for(hook_type, action) << block
    end

    def check_hook(hook_type, action)
      HOOKS[hook_type].include? action
    end

    def registered_hooks
      @registered_hooks ||= {}
    end

    def hooks_for(hook_type, action)
      registered_hooks["#{hook_type}_#{action}".to_sym] ||= []
    end

  end

  private

  def run_hooks(hook_type, action)
    # binding.pry
    self.class.send(:hooks_for, hook_type, action).each do |block|
      instance_eval(&block)
    end
  end

end