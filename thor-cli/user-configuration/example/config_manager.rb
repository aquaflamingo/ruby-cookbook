# lib/mycliapp/config.rb

require 'yaml'
require 'fileutils'

module MyCLIApp
  class AppConfig
    attr_reader :user_name

    def initialize(name)
      @uname = name
    end
  end

  class ConfigManager
    attr_reader :config_path

    DEFAULT_CONFIG_DIR = ".config/mycliapp"

    FILE_CLI_CONFIG = "config.yml"

    # 
    # Initializes the configuration directory if non exists
    #
    def self.init
      unless Dir.exist? @config_dir_path
        FileUtils.mkdir_p(@config_dir_path)

        File.touch(File.join(@config_dir_path, FILE_CLI_CONFIG))
      end
    end
    
    # 
    # Loads the Configuration object
    #
    def self.load
      config_yaml = YAML.load_file(File.join(config_dir_path, FILE_CLI_CONFIG))

      AppConfig.new(config_yaml[:uname])
    end

    private

    def config_dir_path
      @config_dir_path ||= File.join Dir.home, DEFAULT_CONFIG_DIR
    end
  end
end
