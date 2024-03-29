# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "clyde/version"

Gem::Specification.new do |spec|
  spec.name          = "clyde"
  spec.version       = Clyde::VERSION
  spec.authors       = ["Jordan Stephens"]
  spec.email         = ["iam@jordanstephens.net"]
  spec.description   = %q{visually compare pages between two hosts}
  spec.summary       = %q{compares pages between two hosts by taking screenshots over phantomjs and taking the pixel difference of the two images}
  spec.homepage      = "http://github.com/jordanstephens/clyde"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry-debugger"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "puffing-billy"
  spec.add_dependency "colorize"
  spec.add_dependency "thread"
  spec.add_dependency "poltergeist"
  spec.add_dependency "chunky_png"
end
