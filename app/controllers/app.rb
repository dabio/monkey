# encoding: utf-8

module Monkey
  class App

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

    #
    # GET /
    #
    get '/' do
      redirect to('/login')
    end

    before '/login' do
      redirect to('/projects') if has_auth?
    end

    #
    # GET /login
    #
    get '/login' do
      erb :login, locals: { email: '' }
    end

    #
    # POST /login
    #
    post '/login' do
      redirect to('/login') unless params[:email] and params[:password]

      user = User.authenticate(params[:email], params[:password])
      if user
        session[:user_id] = user.id
        redirect to('/projects')
      else
        erb :login, locals: { email: params[:email] }
      end
    end

    #
    # GET /logout
    #
    get '/logout' do
      redirect to ('/login') unless has_auth?

      session[:user_id] = nil
      redirect to('/login')
    end

    error do
      'Error'
    end

  end
end
