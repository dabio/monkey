# encoding: utf-8

module Monkey
  class Campaigns < App

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
    # GET /campaigns/:id
    #
    get '/:id' do |id|
      not_found unless campaign = Campaign.get(id)
      erb :campaign, locals: {
        campaign: campaign,
        campaign_hits: campaign.campaign_hits(limit: 10, order: [:updated_at.desc]),
        orders: campaign.orders(limit: 10, order: [:updated_at.desc]),
      }
    end

    #
    # GET /:id/edit
    #
    get '/:id/edit' do |id|
      erb :campaign_form, locals: { campaign: Campaign.get(id) }
    end

    #
    # PUT /:id
    #
    put '/:id' do |id|
      campaign = Campaign.get(id)

      if campaign.update(params[:campaign])
        redirect to(campaign.link, true, false), success: 'Kampagne erfolgreich gespeichert'
      else
        erb :campaign_form, locals: { campaign: campaign }
      end
    end

    #
    # DELETE /:id
    #
    delete '/:id' do |id|
      campaign = Campaign.get(id)
      project = campaign.project
      campaign.destroy
      flash[:success] = 'Kampagne erfolgreich entfernt'
      to(project.link, true, false)
    end

  end
end
