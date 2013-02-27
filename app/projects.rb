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
    # POST /projects/:id/campaigns
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

  end
end
