class Comment < ActiveRecord::Base
  MAX_LENGTH = 1024

  belongs_to :parent, :polymorphic => true
  belongs_to :user

  validates_presence_of :parent
  validates_presence_of :body
  validates_length_of :body, :maximum => MAX_LENGTH
  validates_presence_of :user
end