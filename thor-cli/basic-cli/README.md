# Basic

A basic Thor CLI application

## Add Thor to gemspec
```ruby
# mycliapp.gemspec

require_relative "lib/mycliapp/version"

Gem::Specification.new do |spec|
  # -- snipped --

  spec.add_dependency "thor", "~> 1.2.1"
  spec.add_development_dependency "pry", "~> 0.14.0"
end
```
[See mycliapp.gemspec](./example/mycliapp.gemspec)

## Create CLI 
```ruby
# mycliapp/cli.rb

require "thor"

module MyCLIApp

  # The CLI 
  class CLI < Thor
    package_name "mycliapp"

    # Returns exit with non zero status when an exception occurs
    def self.exit_on_failure?
      true
    end

    #
    # Returns version of the cli
    #
    desc "version", "Prints the current version"
    def version
      puts MyCLIApp::VERSION
    end
  end
end
```
[See cli.rb](./example/cli.rb)
