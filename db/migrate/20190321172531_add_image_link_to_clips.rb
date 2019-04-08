class AddImageLinkToClips < ActiveRecord::Migration[5.2]
  def change
     add_column :clips, :gcloud_image_link, :string
  end
end
