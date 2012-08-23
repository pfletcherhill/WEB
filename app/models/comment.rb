class Comment < ActiveRecord::Base
  attr_accessible :body, :user_id, :post_id
  
  belongs_to :post
  belongs_to :user
  
  def as_json
  {
    "id" => read_attribute(:id),
    "body" => read_attribute(:body),
    "user" => user,
    "created_at" => read_attribute(:created_at)
   }
  end
end
