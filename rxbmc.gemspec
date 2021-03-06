# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rxbmc/version'

Gem::Specification.new do |spec|
  spec.name          = "rxbmc"
  spec.version       = Rxbmc::VERSION
  spec.authors       = ["Jonathan."]
  spec.email         = ["jonathan.borg.frodin@gmail.com"]
  spec.summary       = %q{A cli tool for controlling an xbmc server}
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "thor", "~>0.18.1"
  spec.add_runtime_dependency "pry"
  spec.add_runtime_dependency "iconv"
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
