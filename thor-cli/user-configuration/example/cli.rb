require 'thor'
require_relative 'mycliapp/command/config.rb'

module MyCLIApp
  class CLI < Thor
    package_name "mycliapp"

    desc "config", "Manage configuration for the CLI"
    subcommand "config", ConfigCommand

  end
end
