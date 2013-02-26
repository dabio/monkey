# encoding: utf-8

class Order < Base
  include DataMapper::Resource

  property :id,       Serial
  property :order_id, String, length: 20, required: true
  property :total,    Float, required: true
  property :currency, String, length: 10, required: true
  property :quantity, Integer, required: true
  timestamps :at

  belongs_to :campaign
  belongs_to :campaign_hit
  has n, :order_items

  # default ordering
  default_scope(:default).update(order: [:created_at, :id])

  def created_at_formatted(format='%-d. %b %y, %H:%M')
    R18n::l(created_at, format)
  end

  def total_formatted
    R18n::l(total)
  end

  def self.link
    '/orders'
  end

end
