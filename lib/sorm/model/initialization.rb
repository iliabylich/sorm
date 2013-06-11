module SORM::Model::Initialization

  def initialize(options = {})
    options.each do |key, value|
      public_send("#{key}=", value) if respond_to?("#{key}=")
    end
  end

end