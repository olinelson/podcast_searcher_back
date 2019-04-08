class Tag < ApplicationRecord
    has_many :cliptags
    has_many :clips, through: :cliptags

end
