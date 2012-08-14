class Bucket < ActiveRecord::Base
  attr_accessible :name, :description, :user_id, :team_id
  
  belongs_to :team
  belongs_to :user
  has_many :containments
  has_many :posts, :through => :containments
  
  validates_uniqueness_of(:name, :scope => :team_id)
end
