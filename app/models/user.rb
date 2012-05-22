class User < ActiveRecord::Base
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable

  validates_format_of :username, :with => /^[\w]{1,20}$/, :message => "must only consist of letters, numbers, and underscores"
  validates_uniqueness_of :username

  attr_accessible :email, :username, :password, :password_confirmation, :remember_me

  after_create lambda { |u| u.confirm! }
  has_many :favorites, :order => 'created_at DESC'
  has_many :comments, :order => 'created_at DESC'
end
