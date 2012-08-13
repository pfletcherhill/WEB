class Post < ActiveRecord::Base
  attr_accessible :title, :body, :team_id, :user_id, :promoted, :user
  
  #validates_presence_of :body, :user_id, :team_id
  
  belongs_to :user
  belongs_to :team
  has_many :likes
  has_many :containments
  has_many :buckets, :through => :containments
  
  accepts_nested_attributes_for :user 
end
