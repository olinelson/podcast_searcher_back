class Episode < ApplicationRecord
    has_one_attached :audio_file
    belongs_to :podcast

    def audio_file_url
     if self.audio_file.attached?
        Rails.application.routes.url_helpers.rails_blob_path(self.audio_file, only_path: true)
       
    else
        nil
     end
    end
end
