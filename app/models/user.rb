class User < ActiveRecord::Base
  
  attr_accessible :password, :password_confirmation, :bio, :year, :school, :name, :email, :admin
  attr_accessor :password, :password_confirmation
  
  before_save :encrypt_password    
	
  validates_presence_of :name  
  validates_presence_of :email 
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"
  validates_uniqueness_of :email
  validates_presence_of :password_confirmation, :on => :onboard
  validates_presence_of :password, :on => :onboard
  validates_confirmation_of :password, :on => :onboard
  validates_presence_of :access_controls
	
	has_many :posts
	has_many :access_controls
	has_many :teams, :through => :access_controls
	has_many :likes
	has_many :buckets
	has_many :comments
		
  def encrypt_password  
    if password.present?  
  		self.password_salt = BCrypt::Engine.generate_salt  
  		self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)  
  	end  
  end 
  
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  
  def activated?
    if password_salt && password_hash
      true
    else
      false
    end
  end
  
  def as_embedded_json
  {
    "id" => read_attribute(:id),
    "name" => read_attribute(:name),
    "email" => read_attribute(:email),
    "bio" => read_attribute(:bio),
    "school" => read_attribute(:school),
    "year" => read_attribute(:year),
    "team_id" => read_attribute(:team_id),
    "teams" => teams
   }
  end
end
