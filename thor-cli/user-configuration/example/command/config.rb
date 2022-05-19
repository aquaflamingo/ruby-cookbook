# mycliapp/command/config.rb

require 'thor'
require_relative 'mycliapp/config_manager.rb'

module MyCLIApp
  class ConfigCommand < Thor
    desc "init", "Initialize the configuration for the CLI"
    def init
      ConfigManager.init
    end
  end
end
