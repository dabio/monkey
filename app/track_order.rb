# encoding: utf-8

module Monkey
  class TrackOrder < App

    use Rack::Protection, :except => [:session_hijacking, :http_origin]

    #
    # GET /track/[A-Za-z0-9\-_=]{32}.gif
    #
    get %r{/([A-Za-z0-9\-_=]{32})\.html} do |hit_hash|
      not_found unless hit = CampaignHit.first(hit_hash)

      # Create the order
      order = Order.new(campaign_hit: hit, campaign: hit.campaign)
      [:order_id, :currency, :total, :quantity].each do |property|
        if params[:order].has_key?(property.to_s)
          order.attributes = { property => params[:order][property] }
          params[:order].delete(property.to_s)
        end
      end

      if order.save
        # Create order items
        params[:order].each do |key, value|
          if value.is_a?(Hash)
            OrderItem.create(order: order, parameter: URI.unescape(value.to_json))
          end
        end
      end

      erb hit.campaign.script_template, locals: { order: order }, layout: false
    end

  end
end
