# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ya_queen_role_fontana/version'

Gem::Specification.new do |spec|
  spec.name          = "ya_queen_role_fontana"
  spec.version       = YaQueenRoleFontana::VERSION
  spec.authors       = ["akima"]
  spec.email         = ["t-akima@groovenauts.jp"]
  spec.description   = %q{defines server deployment role for fontana}
  spec.summary       = %q{defines server deployment role for fontana}
  spec.homepage      = "secret"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "ya_queen", "~> 0.0.4"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
