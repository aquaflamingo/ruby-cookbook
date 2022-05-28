# Autoload

Unlike Ruby on Rails, Sinatra does not provide constant auto-loading by default. However, building auto-loading into Sinatra is trivial.

## Loading Gems via Bundler
Gems managed via Bundler and the Gemfile can be imported via `Bundle.require`. When called Bundler reads through the Gemfile and loads the listed gems into the runtime environment.
```ruby
# app.rb

require 'bundler'
Bundler.require

class App < Sinatra::Base
end
```
[See app.rb](./example/app.rb)

## Loading Application Code
With Gems loaded into the application we now want to load our application code. To do this we can use Sinatra  [configuration](http://sinatrarb.com/configuration.html). The `set` method creates an application wide attribute using a setting name and value as arguments. These values are retrievable from the root class (i.e. `App`). In our case we set the value root to as a relative file path to our project's root directory. Once the root value is set, the application will `require` a new file called `config/autoload.rb`. This file contains logic to load application specific code into the runtime environment

```ruby
# app.rb

# -- snipped --

class App < Sinatra::Base
  set :root_dir, File.dirname(__FILE__)
  require File.join(root_dir, '/config/autoload.rb')
end
```
[See app.rb](./example/app.rb)

Next you create a `config/autoload.rb` file to perform the file loading for all directories in your application.

```ruby

# config/autoload.rb
# Gem specific sub-imports and other requirements
require 'sinatra/base'

# The +DIRECTORIES+ constant holds the list of application directories for the app
# When new directories are added to the application, they need to be appended here.
DIRECTORIES = %w[config].freeze

DIRECTORIES.each do |d|

  # For each directory we construct a path to all ruby files (*.rb) in that directory
  ruby_files_in_dir = File.join(d, '*.rb')

  # Using the relative location we construct a path from the root directory of the app to load the files
  files_path = File.join(App.root_dir, ruby_files_in_dir)

  # We then iterate through each rub file in that directory and require it
  Dir[files_path].sort.each do |f|
    # But we do not want to load the autoloading file as this will recursively execute this process
    next if f.include?('autoload')

    require f
  end
end
```
[See config/autoload.rb](./example/config/autoload.rb)
