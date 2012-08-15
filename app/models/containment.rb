class Containment < ActiveRecord::Base
  attr_accessible :bucket_id, :post_id
  
  belongs_to :post, :foreign_key => :post_id
  belongs_to :bucket, :foreign_key => :bucket_id
  
  validates_presence_of :post_id
  validates_presence_of :bucket_id
  validates_uniqueness_of(:post_id, :scope => :bucket_id)
end
