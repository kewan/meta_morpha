# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'morpha/version'

Gem::Specification.new do |spec|
  spec.name          = "Morpha"
  spec.version       = Morpha::VERSION
  spec.authors       = ["Kewan Shunn"]
  spec.email         = ["kewan@kewanshunn.com"]
  spec.description   = %q{Allows you to define mappings to format data from a hash}
  spec.summary       = %q{Format like a Morpha}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.13.0"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "rest-client"
end
