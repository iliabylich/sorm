require 'sdbm'

module SORM
  class Storage

    attr_accessor :config, :db

    def initialize(config)
      run_hook(:before_initialize, config)

      @config = config
      @db = SDBM.open config[:database]

      run_hook(:after_initialize, db)
    end

    def get(key)
      run_hook(:before_get, key)
      value = db[key]
      run_hook(:after_get, key, value)
      value
    end

    def set(key, value)
      run_hook(:before_set, key, value)
      db[key] = value
      run_hook(:after_set, key, value)
      value
    end

    def clear
      run_hook(:before_clear)
      db.clear
      run_hook(:after_clear)
    end

    def keys
      db.keys
    end

    alias :[] :get
    alias :[]= :set

    class << self

      def hook_objects
        @hook_objects ||= []
      end

      def add_hook_object(hook_object)
        hook_objects << hook_object
      end

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

  end
end