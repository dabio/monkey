# encoding: utf-8

module Monkey
  class Projects < App

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
    # GET /projects
    #
    get '/' do
      erb :projects, locals: { projects: Project.all }
    end

    #
    # POST /projects
    #
    post '/' do
      project = Project.new(params[:project])

      if project.save
        redirect to(Project.link, true, false), success: 'Projekt erfolgreich erstellt'
      else
        project.errors.clear! unless params[:project]
        erb :project_form, locals: { project: project }
      end
    end

    #
    # GET /projects/:id
    #
    get '/:id' do |id|
      erb :project, locals: { project: Project.get(id) }
    end

    #
    # GET /projects/:id/edit
    #
    get '/:id/edit' do |id|
      erb :project_form, locals: { project: Project.get(id) }
    end

    #
    # PUT /projects/:id
    #
    put '/:id' do |id|
      project = Project.get(id)

      if project.update(params[:project])
        redirect to(project.link, true, false), success: 'Projekt erfolgreich gespeichert'
      else
        erb :project_form, locals: { project: project }
      end
    end

    #
    # DELETE /projects/:id
    #
    delete '/:id' do |id|
      Project.get(id).destroy
      flash[:success] = 'Projekt erfolgreich gelöscht'
      to(Project.link, true, false)
    end

    #
    # GET /projects/:project_id
    #
    post '/:id/campaigns' do |id|
      campaign = Campaign.new(params[:campaign])
      campaign.project = Project.get(id)

      if campaign.save
        redirect to(campaign.project.link, true, false), success: 'Kampagne erfolgreich erstellt'
      else
        campaign.errors.clear! unless params[:campaign]
        erb :campaign_form, locals: { campaign: campaign }
      end
    end

    #
    # GET /projects/:id/campaigns/:id
    #
    get '/:id/campaigns/:id' do |id, campaign_id|
      not_found unless campaign = Campaign.get(campaign_id)
      erb :campaign, locals: {
        campaign: campaign,
        campaign_hits: CampaignHit.all(campaign: campaign, limit: 10, order: [:updated_at.desc]),
        orders: Order.all(campaign: campaign, limit: 10, order: [:updated_at.desc]),
      }
    end

    #
    # GET /projects/:id/campaigns/:id/edit
    #
    get '/:id/campaigns/:id/edit' do |id, campaign_id|
      erb :campaign_form, locals: { campaign: Campaign.get(campaign_id) }
    end

    #
    # PUT /projects/:id/campaigns/:id
    #
    put '/:id/campaigns/:id' do |id, campaign_id|
      campaign = Campaign.get(campaign_id)

      if campaign.update(params[:campaign])
        redirect to(campaign.link, true, false), success: 'Kampagne erfolgreich gespeichert'
      else
        erb :campaign_form, locals: { campaign: campaign }
      end
    end

    #
    # DELETE /projects/:id/campaigns/:id
    #
    delete '/:id/campaigns/:id' do |id, campaign_id|
      Campaign.get(campaign_id).destroy
      flash[:success] = 'Kampagne erfolgreich entfernt'
      to(Project.get(id).link, true, false)
    end

    #
    # DELETE /projects/:id/campaigns/:id/hits/:id
    #
    delete '/:id/campaigns/:id/hits/:id' do |id, campaign_id, hit_id|
      CampaignHit.get(hit_id).destroy
      flash[:success] = 'Eintrag gelöscht'
      to(Campaign.get(campaign_id).link, true, false)
    end

  end
end
