# Module with base presistence methods
#
module SORM::Model::Persistence

  # Include hook for adding self-methods.
  #
  def self.included(klass)
    klass.send(:extend, ClassMethods)
  end

  # Module with class methods
  #
  module ClassMethods

    # Returns all records
    #
    # @return [Array<Object>]
    #
    # @example Usage:
    #   class Model < SORM::Model
    #     attribute :first_name
    #     attribute :last_name
    #   end
    #
    #   Model.all
    #
    #   # =>  [#<SimpleModel @firt_name="Krokodil" @last_name="Gena", @sorm_id="some-id">]
    #
    def all
      raw_all.map { |sorm_data| from_sorm(sorm_data) }
    end

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

    private

    # @private
    #
    def from_sorm(sorm_data)
      parsed_json = JSON.parse(sorm_data)
      self.new.tap do |result|
        parsed_json.each do |attr_name, attr_value|
          result.public_send("#{attr_name}=", attr_value) if attr_name != "sorm_id"
        end
        result.send("sorm_id=", parsed_json["sorm_id"])
        result.persist!
      end
    end

    # @private
    #
    def raw_all
      SORM.storage.db.select { |key, value| key.start_with? self.name }.map(&:last)
    end

  end

  # Saves object to SDBM
  #
  # @example
  #   class Model < SORM::Model
  #     attribute :first_name
  #     attribute :last_name
  #   end
  #
  #   m = Model.new(first_name: "Krokodil", last_name: "Gena")
  #   m.save
  #
  #   # =>  true
  def save
    return if persisted?
    self.send(:sorm_id=, UUID.generate) unless self.sorm_id
    SORM.storage[sorm_key] = sorm_attributes.to_json
    @persisted = true
  end

  # Returns sorm id (internal SORM id)
  # (By default, uses UUID to generate id)
  #
  # @return [String]
  #
  attr_accessor :sorm_id
  private :sorm_id=

  # Checks for object persistence
  #
  # @return [true, false]
  #
  def persisted
    @persisted ||= false
  end
  alias :persisted? :persisted

  # Marks object as persisted
  #
  def persist!
    @persisted = true
  end

  protected

  def sorm_attributes
    default_attributes = self.class.send(:extended_attributes).map { |attribute| [attribute, send(attribute)] }
    Hash[default_attributes]
  end

  def sorm_key
    "#{self.class}_#{sorm_id}"
  end

end
