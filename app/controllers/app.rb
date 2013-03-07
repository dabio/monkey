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
      redirect to('/projects')
    end

    before '/login' do
      redirect to('/projects') if has_auth?
      @to = params[:to] ? params[:to] : '/projects'
    end

    #
    # GET /login
    #
    get '/login' do
      erb :login, locals: { email: '', to: @to }
    end

    #
    # POST /login
    #
    post '/login' do
      redirect to('/login') unless params[:email] and params[:password]

      user = User.authenticate(params[:email], params[:password])
      if user
        session[:user_id] = user.id
        redirect to(params[:to], true, false)
      else
        erb :login, locals: { email: params[:email], to: @to }
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
