# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "sorm"
  gem.version       = "1.0.0"
  gem.authors       = ["Ilya Bylich"]
  gem.email         = ["ilya.bylich@productmadness.com"]
  gem.description   = %q{ORM with sdbm as a data storage}
  gem.summary       = %q{ORM with sdbm as a data storage}
  gem.homepage      = ""

  gem.files         = Dir["lib/**/*.rb"]
  gem.executables   = []
  gem.test_files    = Dir["spec/**/*.rb"]
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'redcarpet'
  gem.add_development_dependency 'yard'
end
