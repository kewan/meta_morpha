# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'morpha/version'

Gem::Specification.new do |spec|
  spec.name          = "Morpha"
  spec.version       = Morpha::VERSION
  spec.authors       = ["Kewan Shunn"]
  spec.email         = ["kewan@kewanshunn.com"]
  spec.description   = %q{Allows you to define mappings from html}
  spec.summary       = %q{Format like a Morpha}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.6.2.1"
  spec.add_dependency "rest-client", "~> 1.6.7"

  spec.add_development_dependency "bundler", "~> 1.6.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0"
end
