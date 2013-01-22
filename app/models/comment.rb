class Comment < ActiveRecord::Base
  MAX_LENGTH = 1024

  belongs_to :parent, :polymorphic => true
  belongs_to :user

  validates_presence_of :parent
  validates_presence_of :body
  validates_length_of :body, :maximum => MAX_LENGTH
  validates_presence_of :user

  def self.with_recent_unique_parents
    select('t1.*').from('comments t1').joins("left join comments t2 ON t1.parent_id=t2.parent_id AND t1.created_at < t2.created_at").where('t2.parent_id IS NULL').order('t1.created_at DESC').includes(:parent => {:comments => :user})
  end
end