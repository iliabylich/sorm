module SORM
  module Models
    module Initialization

      def initialize(options = {})
        options.each do |key, value|
          public_send("#{key}=", value) if respond_to?("#{key}=")
        end
      end

    end
  end
end