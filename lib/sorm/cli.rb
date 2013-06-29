require 'erb'

class SORM::CLI

  HELP_MESSAGE = <<-HERE

  Usage:

  sorm create User email password
  sorm create BlankModel
  sorm create Profile name

  HERE

  attr_accessor :command, :klass, :fields

  def initialize(*args)
    @command, @klass, *@fields = args
    @command ||= "--help"
  end

  def run
    case command
    when "--help", "-h" then run_help
    when "create"       then run_create
    end
  end

  class << self

    def run(*args)
      new(*args.flatten).run
    end

  end

  def run_help
    puts HELP_MESSAGE
  end

  def run_create
    File.open(filename, "w") { |f| f.write(template) }
  end

  def raw_template
    @_raw_template ||= begin
      File.read(File.expand_path("../cli_template.erb", __FILE__))
    end
  end

  def template
    ERB.new(raw_template, nil, "<>").result(binding)
  end

  def filename
    klass.gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase + ".rb"
  end

end
