class User < ApplicationRecord

    has_many :clips

    validates :username, uniqueness: true

    has_secure_password
 

end
