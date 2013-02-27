# encoding: utf-8

class Campaign < Base
  include DataMapper::Resource

  property :id,               Serial
  property :title,            String, length: 100, required: true
  property :campaign_hash,    String, length: 64
  property :cookie_lifetime,  Integer
  property :parameter_name,   String, length: 20
  property :parameter_value,  String, length: 20
  property :script_template,  Text
  timestamps :at

  # associations
  belongs_to :project
  has n, :campaign_hits
  has n, :orders

  # default ordering
  default_scope(:default).update(order: [:title, :id])

  # create a unique campaign hash when creating a new campaign
  before :create do |c|
    c.campaign_hash = c.project.url_hash
  end

  before :destroy do |p|
    # deletes all affiliated campaigns of this project
    p.campaign_hits.each do |ch|
      ch.destroy
    end
  end

  class << self

    def link
      '/campaigns'
    end

    def createlink(project)
      [project.link, 'campaigns'].join('/')
    end

  end
end
