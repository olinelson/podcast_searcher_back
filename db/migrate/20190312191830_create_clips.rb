class CreateClips < ActiveRecord::Migration[5.2]
  def change
    create_table :clips do |t|
      t.string :name
      t.string :length
      t.string :transcript
      t.string :words
      t.string :gcloud_service_link

      t.timestamps
    end
  end
end
