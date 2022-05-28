# User Configuration
For certain CLI applications you are developing you may want to persist a set of configuration values for the CLI for future use cases. This patterns stores user specified configurations in a user's $HOME directory for load an later user by the application.

## CLI Config Command
We want to setup a `config` sub command for our CLI. For example `mycliapp config init`.

This can be done trivially via Thor. First we must use the Thor class method `subcommand` and supply it a constant which maps to the class which is meant to handle that command set. In practice, Thor subcommands are just like "miniture" thor CLIs wrapped into a bigger CLI.
```ruby
# lib/mycliapp/cli.rb

require 'thor'
require_relative 'mycliapp/command/config.rb'

module MyCLIApp
  class CLI < Thor
    package_name "mycliapp"

    desc "config", "Manage configuration for the CLI"
    subcommand "config", ConfigCommand

  end
end
```
[See CLI](./example/cli.rb)

Now the `ConfigCommand` class: 
```ruby
# lib/mycliapp/command/config.rb

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
```
[See ConfigCommand](./example/command/config.rb)

## Configuration
Finally, we need to the actual `ConfigManager` and `AppConfig` which will initialize, load and store values from a configuration file.
```ruby
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
```

See [ConfigManager](./example/config_manager.rb)
