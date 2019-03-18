class AddGcloudMediaLinkToClips < ActiveRecord::Migration[5.2]
    def change
    add_column :clips, :gcloud_media_link, :string
  end
end
