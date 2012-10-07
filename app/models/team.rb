class Team < ActiveRecord::Base
  
  attr_accessible :name, :description
  
  has_many :access_controls
  has_many :users, :through => :access_controls
  has_many :posts
  has_many :buckets
  
  accepts_nested_attributes_for :posts
end
