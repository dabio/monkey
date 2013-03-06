# encoding: utf-8

class Permission < Base
  include DataMapper::Resource

  property :id,   Serial
  timestamps :at

  belongs_to :project
  belongs_to :report
  belongs_to :user

end
