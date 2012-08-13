class Containment < ActiveRecord::Base
  belongs_to :post, :foreign_key => :post_id
  belongs_to :bucket, :foreign_key => :bucket_id
  
  validates_uniqueness_of(:post_id, :scope => :bucket_id)
end
