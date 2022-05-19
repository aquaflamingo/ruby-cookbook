# app.rb

require 'bundler'
Bundler.require

class App < Sinatra::Base
  set :root_dir, File.dirname(__FILE__)
  require File.join(root_dir, '/config/autoload.rb')
end
