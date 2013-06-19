# Module with initialize method
#
module SORM::Model::Initialization

  # @param options [Hash] hash with attribute in format { attribute => value  }
  #
  # @example
  #   class Model
  #     attribute :name
  #   end
  #
  #   Model.new(name: "Gena")
  #   # => #<Model @name="Gena", @sorm_id=nil>
  #
  def initialize(options = {})
    options.each do |key, value|
      public_send("#{key}=", value) if respond_to?("#{key}=")
    end
  end

end