# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-json-nest2flat"
  spec.version       = "0.0.2"
  spec.authors       = ["Fukui ReTu"]
  spec.email         = ["s0232101@gmail.com"]
  spec.description   = %q{Output filter plugin to convert to a flat structure the JSON that is nest}
  spec.summary       = %q{Output filter plugin to convert to a flat structure the JSON that is nest}
  spec.homepage      = "https://github.com/fukuiretu/fluent-plugin-json-nest2flat"
  spec.license       = "Apache"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
