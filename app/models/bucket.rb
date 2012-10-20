class Bucket < ActiveRecord::Base
  attr_accessible :name, :description, :user_id, :team_id
  
  belongs_to :team
  belongs_to :user
  has_many :containments
  has_many :posts, :through => :containments
  
  validates_uniqueness_of(:name, :scope => :team_id)
  
  def as_json
  {
    "id" => read_attribute(:id),
    "name" => read_attribute(:name),
    "description" => read_attribute(:description),
    "team_id" => read_attribute(:team_id),
    "user_id" => read_attribute(:user_id),
    "posts" => posts.as_json
   }
  end
end
