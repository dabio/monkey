# encoding: utf-8
require 'securerandom'

class Project
  include DataMapper::Resource

  property :id,           Serial
  property :title,        String, length: 100, required: true
  property :project_hash, String, length: 64
  timestamps :at

  # associations
  has n, :campaigns

  # default ordering
  default_scope(:default).update(order: [:title, :id])

  # create a unique project hash when creating a new project
  before :create do |p|
    p.project_hash = url_hash
  end

  before :destroy do |p|
    # deletes all affiliated campaigns of this project
    p.campaigns.each do |c|
      c.destroy
    end
  end

  def url_hash
    SecureRandom.urlsafe_base64(24, true)
  end

  def link
    [self.class.link, id].join('/')
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

    def link
      '/projects'
    end

    def createlink
      self.link
    end

  end

end
