# basic.gemspec

require_relative "lib/mycliapp/version"

Gem::Specification.new do |spec|
  # -- snipped --

  spec.add_dependency "thor", "~> 1.2.1"
  spec.add_development_dependency "pry", "~> 0.14.0"
end
