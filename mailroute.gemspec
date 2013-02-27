# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailroute/version'

Gem::Specification.new do |spec|
  spec.name          = "mailroute"
  spec.version       = Mailroute::VERSION
  spec.authors       = ["Viktar Basharymau"]
  spec.email         = ["Viktar.Basharymau@gmail.com"]
  spec.description   = %q{MailRoute API}
  spec.summary       = %q{An API for http://mailroute.net}
  spec.homepage      = "http://github.com/DNNX/mailroute"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'rest-client'
  spec.add_dependency 'json_pure'
  spec.add_dependency 'activeresource'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rb-inotify"
  spec.add_development_dependency "rb-fsevent"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "awesome_print"
end
