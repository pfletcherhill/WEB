class Post < ActiveRecord::Base
  attr_accessible :title, :body, :team_id, :user_id, :promoted, :image_id
  
  #validates_presence_of :body, :user_id, :team_id
  
  belongs_to :user
  belongs_to :team
  has_many :likes
  has_many :containments
  has_many :buckets, :through => :containments
  belongs_to :image
  has_many :comments
  
  def as_json
  {
    "id" => read_attribute(:id),
    "title" => read_attribute(:title),
    "body" => read_attribute(:body),
    "user" => user,
    "likes" => likes,
    "comments" => comments.as_json,
    "image" => image,
    "promoted" => read_attribute(:promoted),
    "created_at" => read_attribute(:created_at)
   }
  end
end
