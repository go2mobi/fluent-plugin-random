Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-random"
  spec.version       = "0.0.1"
  spec.authors       = ["Neozaru"]
  spec.email         = ["neozaru@mailoo.org"]
  spec.description   = %q{Fluentd custom plugin to generate random values}
  spec.summary       = %q{Fluentd custom plugin to generate random values}
  spec.homepage      = "https://github.com/Neozaru/fluent-plugin-random.git"
  spec.license       = "WTFPL"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "fluentd"
end
