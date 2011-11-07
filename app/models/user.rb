class User < ActiveRecord::Base
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable

  validates_format_of :username, :with => /^[\w]{1,20}$/, :message => "must only consist of letters, numbers, and underscores"

  attr_accessible :email, :username, :password, :password_confirmation, :remember_me
end
