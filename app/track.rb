# encoding: utf-8

module Monkey
  class Track < App

    use Rack::Protection, :except => :session_hijacking

    #
    # GET /track/[A-Za-z0-9\-_=]{32}.js
    #
    get %r{/([A-Za-z0-9\-_=]{32})\.js}, :provides => 'js' do |code|
      not_found unless project = Project.first(project_hash: code)

      erb :track, layout: false, locals: {
        campaigns: campaign_dictionary(project),
        project: project,
        campaign_hit_hash: project.url_hash
      }
    end

    #
    # GET /track/[A-Za-z0-9\-_=]{32}/[A-Za-z0-9\-_=]{32}.gif
    #
    get %r{/([A-Za-z0-9\-_=]{32})\/([A-Za-z0-9\-_=]{32})\.gif} do |campaign_hash, hit_hash|
      content_type 'image/gif'
      not_found unless campaign = Campaign.first(campaign_hash: campaign_hash)

      hit = CampaignHit.first(campaign_hit_hash: hit_hash)
      if hit
        hit.update(updated_at: Time.now, campaign: campaign)
      else
        CampaignHit.create(campaign_hit_hash: hit_hash, campaign: campaign)
      end

      File.read(File.join('public', 'images', 'track.gif'))
    end


    # Returns a string with all campaign hashes of the given project.
    def campaign_dictionary(project)
      campaigns = project.campaigns.map do |c|
        {
          campaign_hash: c.campaign_hash,
          cookie_lifetime: c.cookie_lifetime,
          parameter_name: c.parameter_name,
          parameter_value: c.parameter_value
        }
      end
    end

  end
end
