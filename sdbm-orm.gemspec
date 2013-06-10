# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "sorm"
  gem.version       = "0.0.1"
  gem.authors       = ["Ilya Bylich"]
  gem.email         = ["ilya.bylich@productmadness.com"]
  gem.description   = %q{ORM with sdbm as a data storage}
  gem.summary       = %q{ORM with sdbm as a data storage}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
end
