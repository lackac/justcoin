# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'justcoin/version'

Gem::Specification.new do |spec|
  spec.name          = "justcoin"
  spec.version       = Justcoin::VERSION
  spec.authors       = ["Laszlo Bacsi"]
  spec.email         = ["lackac@lackac.hu"]
  spec.description   = %q{Justcoin API client}
  spec.summary       = %q{Justcoin API client}
  spec.homepage      = "https://github.com/lackac/justcoin"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
