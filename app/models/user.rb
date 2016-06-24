class User < ActiveRecord::Base

  has_many :resources

  has_secure_password
  
end