class Bucket < ActiveRecord::Base
  attr_accessible :title, :body
  
  belongs_to :team
  belongs_to :user
  has_many :containments
  has_many :posts, :through => :containments
end
