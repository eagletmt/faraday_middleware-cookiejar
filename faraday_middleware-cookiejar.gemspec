# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faraday_middleware/cookiejar/version'

Gem::Specification.new do |spec|
  spec.name          = "faraday_middleware-cookiejar"
  spec.version       = FaradayMiddleware::Cookiejar::VERSION
  spec.authors       = ["eagletmt"]
  spec.email         = ["eagletmt@gmail.com"]
  spec.description   = %q{Faraday middleware for managing cookies}
  spec.summary       = %q{Faraday middleware for managing cookies}
  spec.homepage      = "https://github.com/eagletmt/faraday_middleware-cookiejar"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "cookiejar"
  spec.add_dependency "faraday"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
