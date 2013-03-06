# encoding: utf-8

class User < Base
  include DataMapper::Resource

  property :id,       Serial
  property :email,    String, required: true, format: :email_address, unique: true
  property :password, SCryptHash, required: true
  property :name,     String, length: 50
  property :is_admin, Boolean, default: false
  timestamps :at

  has n, :permissions
  has n, :projects, through: :permissions
  has n, :reports, through: :permissions

  attr_accessor :password_confirmation
  validates_confirmation_of :password, if: :password_required?

  before :destroy do |user|
    # remove all permissions for this user
    user.permissions.each do |p|
      p.destroy
    end
  end

  class << self

    def authenticate(email, password)
      return nil unless user = User.first(email: email)
      user.password == password ? user : nil
    end

    def link
      '/users'
    end

  end

  private

    def password_required?
      password && !password.empty?
    end

end
