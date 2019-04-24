class AddYoutubeUrlToClips < ActiveRecord::Migration[5.2]
  def change
    add_column :clips, :youtube_url, :string
  end
end
