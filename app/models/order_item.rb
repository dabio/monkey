# encoding: utf-8

class OrderItem < Base
  include DataMapper::Resource

  property :id,         Serial
  property :parameter,  Text
  timestamps :at

  belongs_to :order

  def parameter_formatted
    JSON.pretty_generate JSON.parse(parameter)
  end

end
