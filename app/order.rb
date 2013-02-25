# encoding: utf-8

module Monkey
  class Order < App

    use Rack::Protection, :except => :session_hijacking

    #
    # GET /track/[A-Za-z0-9\-_=]{32}.gif
    #
    get %r{/([A-Za-z0-9\-_=]{32})\.gif} do |hit_hash|
      content_type 'image/gif'
      not_found unless hit = CampaignHit.first(hit_hash)

      # order = Order.new(campaign_hit: hit)
      # order_properties.each do |property|
      #   if params[:order].include?(property)
      #     order.attributes.merge { property: params[:order][:property] }
      #   end
      # end

      puts params[:order]

      File.read(File.join('public', 'images', 'order.gif'))
    end

    def order_properties
      ['order_id', 'currency', 'total', 'quantity']
    end

  end
end
