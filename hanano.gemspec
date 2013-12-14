# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = "hanano"
  spec.version       = '0.0.0'
  spec.authors       = ["aereal"]
  spec.email         = ["aereal@aereal.org"]
  spec.summary       = %q{Parse Hatena Notation-like notation}
  spec.description   = %q{Define and parse the subset or well-defined version of Hatena Notation}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "parslet"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "fuubar"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "terminal-notifier-guard"
  spec.add_development_dependency "coveralls"
end
