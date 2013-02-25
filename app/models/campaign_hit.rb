# encoding: utf-8

class CampaignHit < Base
  include DataMapper::Resource

  property :id,                 Serial
  property :campaign_hit_hash,  String, length: 64
  timestamps :at

  # associations
  belongs_to :campaign
  has n, :orders

  # default ordering
  default_scope(:default).update(order: [:created_at.desc, :id])

  def created_at_formatted(format='%-d. %b %y')
    R18n::l(created_at, format)
  end

  def updated_at_formatted(format='%-d. %b %y')
    R18n::l(updated_at, format)
  end

  def link
    [self.class.link(campaign), id].join('/')
  end

  def editlink
    [link, 'edit'].join('/')
  end

  def deletelink
    link
  end

  def savelink
    link
  end

  class << self

    def link(campaign)
      [campaign.link, 'hits'].join('/')
    end

    def createlink(campaign)
      self.link(campaign)
    end

  end
end
