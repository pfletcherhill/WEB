class Team < ActiveRecord::Base
  
  attr_accessible :name, :description
  
  has_many :access_controls
  has_many :users, :through => :access_controls
  has_many :posts
  has_many :buckets
  
  accepts_nested_attributes_for :posts
  
  def as_embedded_json
  {
    "id" => read_attribute(:id),
    "name" => read_attribute(:name),
    "description" => read_attribute(:description),
    "users" => users,
    "posts" => posts.count,
    "likes" => posts.map{|p| p.likes.count}.sum
   }
  end
end
