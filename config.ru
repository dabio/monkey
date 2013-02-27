# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/app/boot')

run Rack::URLMap.new({

  # Backend
  '/' => Monkey::App,
  '/projects' => Monkey::Projects,
  '/campaigns' => Monkey::Campaigns,
  '/hits' => Monkey::Hits,
  '/orders' => Monkey::Orders,

  # Tracking
  '/track' => Monkey::Track,
  '/track-order' => Monkey::TrackOrder,

})
