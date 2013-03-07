# encoding: utf-8

module Monkey
  class Users < App

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
    # Disallow this area for non authorized users.
    #
    before do
      authorize!
    end

    #
    # GET /users
    #
    get '/' do
      erb :users, locals: { users: User.all }
    end

    #
    # POST /users
    #
    post '/' do
      user = User.new(params[:user])

      if user.save
        redirect to(User.link, true, false), success: 'Nutzer erfolgreich angelegt'
      else
        user.errors.clear! unless params[:user]
        erb :user_form, locals: { user: user }
      end
    end

    #
    # GET /:id/edit
    #
    get '/:id/edit' do |id|
      erb :user_form, locals: { user: User.get(id) }
    end

    #
    # PUT /:id
    #
    put '/:id' do |id|
      user = User.get(id)

      if params[:user][:password].nil? or params[:user][:password].empty?
        params[:user].delete 'password'
        params[:user].delete 'password_confirmation'
      end

      p params[:user]
      if user.update(params[:user])
        redirect to(user.editlink, true, false), success: 'Einstellungen erfolgreich geändert'
      else
        erb :user_form, locals: { user: user }
      end
    end

  end
end
