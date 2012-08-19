class Image < ActiveRecord::Base
  attr_accessible :image
  
  has_many :posts
  
  mount_uploader :image, ImageUploader

  #one convenient method to pass jq_upload the necessary information
  def to_jq_upload
  {
    "id" => read_attribute(:id),
    "title" => read_attribute(:title),
    "post_id" => read_attribute(:post_id),
    "name" => read_attribute(:image),
    "size" => image.size,
    "url" => image.url,
    "thumbnail_url" => image.thumb.url,
    "delete_url" => '/images/#{:id}',
    "delete_type" => "DELETE" 
   }
  end
end
