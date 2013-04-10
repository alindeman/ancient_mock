# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ancient_mock/version'

Gem::Specification.new do |spec|
  spec.name          = "ancient_mock"
  spec.version       = AncientMock::VERSION
  spec.authors       = ["Andy Lindeman"]
  spec.email         = ["alindeman@gmail.com"]
  spec.description   = %q{A simple mock object library I built on stage at Ancient City Ruby. Do not use in production!}
  spec.summary       = %q{A simple mock object library I built on stage at Ancient City Ruby.}
  spec.homepage      = "https://github.com/alindeman/ancient_mock"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 4.7.0"
end
