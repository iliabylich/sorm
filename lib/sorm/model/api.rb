module SORM::Model::API

  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  module ClassMethods

    # Returns record with passed id
    #
    # @param record_id [Fixnum] id of record
    #
    # @return [Object]
    #
    def find(record_id)
      all.detect { |record| record.sorm_id == record_id }
    end

    # Returns all records with passed conditions
    #
    # @param options [Hash] ({}) hash of options
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
    #
    #   # =>  #<SimpleModel @firt_name="Krokodil" @last_name="Gena", @sorm_id="some-id">
    #
    def where(options = {})
      all.select do |record|
        options.all? { |key, value| record.send(key) == value }
      end
    end

    # Returns first record
    #
    # @return [Object]
    #
    def first
      self.all.first
    end

    def create(options = {})
      new(options).tap(&:save)
    end

    def count
      all.count
    end

  end

  def update(options = {})
    options.each do |key, value|
      send("#{key}=", value)
    end
    @persisted = false
    save
  end

end