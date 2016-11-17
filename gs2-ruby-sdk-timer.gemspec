# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gs2/timer/version'

Gem::Specification.new do |spec|
  spec.name          = "gs2-ruby-sdk-timer"
  spec.version       = Gs2::Timer::VERSION
  spec.authors       = ["Game Server Services, Inc."]
  spec.email         = ["contact@gs2.io"]
  spec.licenses		 = "Apache-2.0"

  spec.summary       = %q{Game Server Services GS2-Timer Client Library}
  spec.homepage      = "https://gs2.io/"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "gs2-ruby-sdk-core", "~> 0.1.0"
  
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
end
