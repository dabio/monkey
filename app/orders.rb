# encoding: utf-8

module Monkey
  class Orders < App

    configure do
      enable :sessions
      enable :method_override
      set :default_locale, 'de'
    end

    configure :development do
      set :session_secret, "My Session Secret"
    end

    register Sinatra::Flash
    register Sinatra::R18n

  end
end
