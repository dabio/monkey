# encoding: utf-8

if defined? Encoding
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined? RACK_ENV
ROOT_DIR = File.dirname(File.expand_path(__FILE__))

require 'bundler/setup'
Bundler.require(:default, RACK_ENV)

# PostgreSQL
DataMapper::Logger.new($stdout, :debug) if RACK_ENV == 'development'
DataMapper.setup(:default, ENV['DATABASE_URL'] || 'postgres://dan@localhost/monkey')

Dir[
  './lib/**/*.rb',
  './app/models/base.rb',
  './app/models/*.rb',
].each do |f|
  require f
end

# Finalize Datamapper Models
DataMapper.finalize

module Monkey
  class App < Sinatra::Base

    configure do
      disable :sessions
      set :root, ROOT_DIR
      set :public_folder, "#{ROOT_DIR}/../public"
    end

    configure :production do
      disable :logging
    end

    configure :development do
      enable :logging
      enable :show_exceptions
    end

    configure :test do
      enable :raise_errors
      disable :logging
      disable :reload_templates
    end

  end
end

Dir[
  './app/helpers.rb',
  './app/controllers/app.rb',
  './app/controllers/*.rb'
].each do |f|
  require f
end
