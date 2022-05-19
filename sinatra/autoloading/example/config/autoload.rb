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
