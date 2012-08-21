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
  
  # has_attached_file :thumbnail, 
  #     :styles => { :large => "500x", :medium => "250x" },
  #     :storage => :s3,
  #         :s3_credentials => {
  #           :access_key_id => 'AKIAIGVNEJUWP6KDGC6A',
  #           :secret_access_key => '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',
  #           :bucket => 'The_WEB_Project'
  #         }
  
  accepts_nested_attributes_for :user 

  # def thumbnail_url
  #     thumbnail.url(:large)
  #   end
end
