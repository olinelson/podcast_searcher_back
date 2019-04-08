class AddAudioUploadFormatToClips < ActiveRecord::Migration[5.2]
  def change
    add_column :clips, :audio_upload_format, :string
  end
end
