# encoding: utf-8

class Order < Base
  include DataMapper::Resource

  property :id,       Serial
  property :order_id, String, length: 20, required: true
  property :total,    Float
  property :currency, String, length: 10
  property :quantity, Integer
  timestamps :at

  belongs_to :campaign_hit
  has n, :order_items

end
