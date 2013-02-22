# encoding: utf-8

class OrderItem < Base
  include DataMapper::Resource

  property :id,               Serial
  property :parameter,        Text
  timestamps :at

  belongs_to :order

end
