# Module with utils methods like #find, #where, #first, #last, etc
#
module SORM::Model::API

  # @private
  #
  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  # Module with API class-methods
  module ClassMethods

    # Returns record with passed id
    #
    # @param record_id [Fixnum] id of record
    #
    # @return [Object]
    #
    # @example Usage:
    #   class Model < SORM::Model
    #     attribute :first_name
    #     attribute :last_name
    #   end
    #
    #   Model.find("some-sorm-id")
    #   # => [#<Model @firt_name="Krokodil" @last_name="Gena", @sorm_id="some-sorm-id">]
    #
    def find(record_id)
      all.detect { |record| record.sorm_id == record_id }
    end

    # Returns all records with passed conditions
    #
    # @param options [Hash] hash of options
    #
    # @return [Array<Object>]
    #
    # @example Usage:
    #   class Model < SORM::Model
    #     attribute :first_name
    #     attribute :last_name
    #   end
    #
    #   Model.where(first_name: "Krokodil", last_name: "Gena")
    #   # => [#<Model @firt_name="Krokodil" @last_name="Gena", @sorm_id="some-id">]
    #
    def where(options = {})
      all.select do |record|
        options.all? { |key, value| record.send(key) == value }
      end
    end

    # Returns first record of model
    #
    # @return [Object] if Model.count > 0
    # @return [nil] if Model.count == 0
    #
    # @example Usage:
    #   class Model < SORM::Model
    #     attribute :first_name
    #     attribute :last_name
    #   end
    #
    #   Model.first
    #   # => #<Model @firt_name="Krokodil" @last_name="Gena", @sorm_id="some-id">
    #
    # @see #last
    #
    def first
      self.all.first
    end

    # Returns last record of model
    #
    # @return [Object] if Model.count > 0
    # @return [nil] if Model.count == 0
    #
    # @example Usage:
    #   class Model < SORM::Model
    #     attribute :first_name
    #     attribute :last_name
    #   end
    #
    #   Model.last
    #   # => #<Model @firt_name="Krokodil" @last_name="Gena", @sorm_id="some-id">
    #
    # @see #first
    #
    def last
      self.all.last
    end

    # Creates object and stores it in storage
    #
    # @param options [Hash] hash of attributes
    #
    # @return [Object] saved record if object is valid
    # @return [false] false if object is invalid
    #
    # @example Usage:
    #   class Model < SORM::Model
    #     atribute :first_name
    #     validate :first_name, presence: true
    #   end
    #
    #   Model.create
    #   # => false
    #
    #   Model.create(first_name: "Gena")
    #   # => [#<Model @firt_name="Gena", @sorm_id="some-id">]
    #
    def create(options = {})
      r = new(options)
      r.save ? r : false
    end

    # Returns count of records
    #
    # @return [Fixnum] records amount
    #
    # @example Usage:
    #   class Model < SORM::Model
    #     atribute :first_name
    #     validate :first_name, presence: true
    #   end
    #
    #   Model.create(first_name: "Gena")
    #   # => [#<Model @firt_name="Gena", @sorm_id="some-id">]
    #
    #   Model.count
    #   # => 1
    #
    def count
      all.count
    end

  end

  # Updates attributes of record
  #
  # @return [Object] saved record if object is valid
  # @return [false] false if object is invalid
  #
  # @example Usage:
  #   class Model < SORM::Model
  #     atribute :first_name
  #     validate :first_name, presence: true
  #   end
  #
  #   record = Model.create(first_name: "Gena")
  #   # => [#<Model @firt_name="Gena", @sorm_id="some-id">]
  #
  #   record.update(first_name: "Cheburashka")
  #   # => [#<Model @firt_name="Cheburashka", @sorm_id="some-id">]
  #
  def update(options = {})
    run_hooks(:before, :update)
    options.each do |key, value|
      send("#{key}=", value)
    end
    run_hooks(:after, :update)
    @persisted = false
    save
  end

end