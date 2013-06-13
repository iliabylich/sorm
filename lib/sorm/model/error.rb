class SORM::Model::Error

  attr_accessor :record, :_errors

  def initialize(record)
    @record = record
  end

  def errors
    valid?
    _errors
  end

  def valid?
    each_validation do |attr_name, attr_value, options, block|
      check_presence(attr_name, attr_value) if options[:presence]
      check_uniqueness(attr_name, attr_value) if options[:uniq]
      check_block(attr_name, attr_value, &block) if block
    end
    has_errors?
  end

  private

  def _errors
    @_errors ||= {}
  end

  def validations
    @record.validations
  end

  def each_record_attribute(&block)
    record.attributes.each(&block)
  end

  def each_validation
     each_record_attribute do |attr_name|
      validations_for(attr_name).each do |(_, options, block)|
        yield attr_name, record.attribute(attr_name), options, block
      end
    end
  end

  def check_presence(attr_name, attr_value)
    add_error(attr_name, "Can't be blank") if attr_value.nil? or attr_value == ""
  end

  def check_uniqueness(attr_name, attr_value)
    same_record = record.class.where(attr_name => attr_value).first
    add_error(attr_name, "Should be uniq") if same_record
  end

  def check_block(attr_name, attr_value, &block)
    add_error(attr_name, "Validation block returns false-value") unless block.call(record)
  end

  def add_error(attr_name, message)
    _errors[attr_name] = message
  end

  def has_errors?
    _errors == {}
  end

  def validations_for(attr_name)
    record.class.validations.select { |validation| validation.first == attr_name }
  end

end