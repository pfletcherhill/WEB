class AccessControl < ActiveRecord::Base
  
  attr_accessible :team_id, :user_id
  
  belongs_to :user
  belongs_to :team
  
  validates_uniqueness_of(:team_id, :scope => :user_id)
end
