# -*- encoding: utf-8 -*-
require File.expand_path('../lib/tick/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "motion-tickspot"
  spec.version       = Tick::VERSION
  spec.authors       = ["Brian Pattison"]
  spec.email         = ["brian@brianpattison.com"]
  spec.summary       = "A RubyMotion wrapper for the http://tickspot.com API"
  spec.description   = "Motion Tickspot is a RubyMotion wrapper for accessing the Tick time tracking service using the http://tickspot.com API."
  spec.homepage      = "https://github.com/codelation/motion-tickspot"
  spec.license       = "MIT"

  files = []
  files << 'README.md'
  files.concat(Dir.glob('lib/**/*.rb'))
  spec.files         = files
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "motion-cocoapods", "~> 1.7"
  spec.add_development_dependency "awesome_print_motion", "~> 0.1"
  spec.add_development_dependency "guard-motion", "~> 0.1"
  spec.add_development_dependency "motion-redgreen", "~> 0.1"
  spec.add_development_dependency "RackMotion", "~> 0.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "terminal-notifier-guard", "~> 1.5"
end
