# encoding: utf-8

class Report < Base
  include DataMapper::Resource

  property :id,     Serial
  property :label,  String, required: true, length: 20
  timestamps :at

  has n, :permissions
  has n, :users, through: :permissions

end
