module SORM
  module Models
    module Persistence

      def self.included(klass)
        klass.send(:extend, ClassMethods)
        klass.send(:include, InstanceMethods)
      end

      module ClassMethods

        def all
          SORM.storage.db.select { |key, value| key.start_with? self.name }.map do |(key, sorm_data)|
            from_sorm(sorm_data)
          end
        end

        def find(record_id)
          all.detect do |record|
            record.sorm_id == record_id
          end
        end

        def from_sorm(sorm_data)
          parsed_json = JSON.parse(sorm_data)
          self.new.tap do |result|
            parsed_json.each do |attr_name, attr_value|
              result.send("#{attr_name}=", attr_value)
            end
          end
        end

      end

      module InstanceMethods

        def save
          SORM.storage[sorm_key] = sorm_attributes.to_json
        end

        def to_sorm
          sorm_attributes
        end

        def sorm_attributes
          default_attributes = attributes.map { |attribute| [attribute, send(attribute)] }
          Hash[default_attributes]
        end

        def sorm_key
          "#{self.class}_#{sorm_id}"
        end

        attr_accessor :sorm_id

        def sorm_id
          @sorm_id ||= UUID.generate
        end

      end
    end
  end
end
