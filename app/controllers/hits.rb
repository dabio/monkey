# encoding: utf-8

module Monkey
  class Hits < App

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
    # DELETE /hits/:id
    #
    delete '/:id' do |id|
      hit = CampaignHit.get(id)
      campaign = hit.campaign
      hit.destroy
      flash[:success] = 'Besuch erfolgreich entfernt'
      to(campaign.link, true, false)
    end

  end
end
