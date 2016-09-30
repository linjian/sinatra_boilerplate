# set default env
ENV['RACK_ENV'] ||= 'development'

# require gems listed in the Gemfile
require "bundler/setup"
Bundler.require(:default, ENV['RACK_ENV'])

# require sinatra contrib extensions
require "sinatra/reloader" if development?
require "sinatra/config_file"

# require app_file
require File.expand_path("../app", __FILE__)

# require initialization files
Dir.glob(File.expand_path("../init", __FILE__) + '/*.rb').each do |file|
  require file
end

# require application files
%w{models helpers lib controllers}.each do |dir|
  Dir.glob(File.expand_path("../#{dir}", __FILE__) + '/**/*.rb').each do |file|
    require file
  end
end
