# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kairosdb/version'

Gem::Specification.new do |spec|
  spec.name          = "kairosdb"
  spec.version       = KairosDB::VERSION
  spec.authors       = ["Andre LeBlanc"]
  spec.email         = ["andre.leblanc88@gmail.com"]

  spec.summary       = %q{An unofficial Ruby library for KairosDB.}
  spec.description   = %q{This is an unofficial Ruby library for KairosDB.}
  spec.homepage      = "https://github.com/andremleblanc/kairosdb-ruby"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 1.24.2"
end
