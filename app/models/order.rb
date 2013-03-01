# encoding: utf-8

class Order < Base
  include DataMapper::Resource

  # please also add the defined properties in the class method
  # "fields" below
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

  before :destroy do |o|
    # deletes all affiliated order items of this order
    o.order_items.each do |oi|
      oi.destroy
    end
  end

  def created_at_formatted(format='%-d. %b %y, %H:%M')
    R18n::l(created_at, format)
  end

  def total_formatted
    R18n::l(total)
  end

  class << self
    def fields
      ['order_id', 'total', 'currency', 'quantity']
    end

    def link
      '/orders'
    end
  end

end
