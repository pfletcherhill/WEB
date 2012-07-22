class Team < ActiveRecord::Base
  
  attr_accessible :name, :description
  
  has_many :users
  has_many :posts
  
  accepts_nested_attributes_for :posts
end
