require 'sdbm'

module SORM

  # Base storage class
  #
  class Storage

    attr_accessor :config, :db

    # Base initialize method
    #
    # Runs before/after iniatialize hooks
    #
    # @param [Hash] config connection options
    # @option config [String] :database path to db file
    #
    def initialize(config)
      run_hook(:before_initialize, config)

      @config = config
      raise ::SORM::NotConfigured, "You should configure database path" unless has_config?

      @db = SDBM.open config[:database]

      run_hook(:after_initialize, db)
    end

    # Method for getting data from storage
    #
    # Runs before/after get hooks
    #
    # @see #[]
    # @see #hook_objects
    #
    # @param key [String]
    #
    # @return [String]
    #
    def get(key)
      run_hook(:before_get, key)
      value = db[key]
      run_hook(:after_get, key, value)
      value
    end

    # Method for setting data to storage
    #
    # Runs before/after set hooks
    #
    # @see #[]=
    # @see #hook_objects
    #
    # @param key [String]
    # @param value [String]
    #
    def set(key, value)
      run_hook(:before_set, key, value)
      db[key] = value
      run_hook(:after_set, key, value)
      value
    end

    # Method for flushing storage
    #
    # Runs before/after clear hooks
    #
    def clear
      run_hook(:before_clear)
      db.clear
      run_hook(:after_clear)
    end

    # Returns all keys in storage
    #
    # @return [Array<String>]
    #
    def keys
      db.keys
    end

    alias :[] :get
    alias :[]= :set

    # Removes key from storage
    #
    # @param key [String]
    #
    def delete(key)
      run_hook(:before_delete)
      db.delete(key)
      run_hook(:after_delete)
    end

    class << self

      # Returns all hook objects
      #
      # @return [Array<Object>]
      #
      def hook_objects
        @hook_objects ||= []
      end

      # Adds hook object to storage
      #
      # @param hook_object [Object]
      #
      # @example
      #   class BeforeGetHook
      #     def self.before_clear
      #       puts "Called before clear"
      #     end
      #   end
      #
      #   SORM::Storage.add_hook_object(BeforeGetHook)
      #   storage = SORM::Storage.new(database: "/tmp/temp.db")
      #   storage.clear
      #   # => "Called before clear"
      #
      # List of hooks:
      #   :before_initialize
      #   :after_initialize
      #
      #   :before_get
      #   :after_get
      #
      #   :before_set
      #   :after_set
      #
      #   :before_delete
      #   :after_delete
      #
      #   :before_clear
      #   :after_clear
      #
      def add_hook_object(hook_object)
        hook_objects << hook_object
      end

      # Method for clearing hook objects
      #
      def clear_hooks
        @hook_objects = []
      end

    end

    private

    def run_hook(hook, *payload)
      self.class.hook_objects.each do |hook_object|
        hook_object.send(hook, *payload)
      end
    end

    def has_config?
      @config.is_a?(Hash) and @config[:database].is_a?(String)
    end

  end
end