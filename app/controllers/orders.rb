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

    #
    # Disallow this area for non authorized users.
    #
    before do
      not_found unless has_auth?
    end

    #
    # GET /orders/:id
    #
    get '/:id' do |id|
      not_found unless order = Order.get(id)
      erb :order, locals: { order: order }
    end

    #
    # DELETE /orders/:id
    #
    delete '/:id' do |id|
      order = Order.get(id)
      campaign = order.campaign
      order.destroy
      flash[:success] = 'Order erfolgreich entfernt'
      to(campaign.link, true, false)
    end

  end
end
