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
