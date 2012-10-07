class AccessControl < ActiveRecord::Base
  belongs_to :user
  belongs_to :team
  
  validates_uniqueness_of(:team_id, :scope => :user_id)
end
