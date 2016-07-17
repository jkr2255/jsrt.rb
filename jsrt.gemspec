# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsrt/version'

Gem::Specification.new do |spec|
  spec.name          = 'jsrt'
  spec.version       = JSRT::VERSION
  spec.authors       = ['jkr2255']
  spec.email         = ['jkr2255@users.noreply.github.com']

  spec.summary       = 'Run JavaScript via Microsoft JavaScript Runtime (JSRT).'
  spec.homepage      = 'https://github.com/jkr2255/jsrt.rb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
