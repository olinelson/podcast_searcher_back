class User < ApplicationRecord

    
    has_many :user_clips
    has_many :clips, through: :user_clips
    validates :email, uniqueness: true

    has_secure_password
 
    

end
