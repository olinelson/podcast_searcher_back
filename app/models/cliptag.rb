class Cliptag < ApplicationRecord
    belongs_to :clip 
    belongs_to :tag
end
