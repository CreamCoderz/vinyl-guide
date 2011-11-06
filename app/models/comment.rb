class Comment < ActiveRecord::Base
  belongs_to :parent, :polymorphic => true
  belongs_to :user

  validates_presence_of :parent
  validates_presence_of :body
  validates_presence_of :user
end