class CreateEpisodes < ActiveRecord::Migration[5.2]
  def change
    create_table :episodes do |t|
      t.string :name
      t.string :length
      t.string :metadata
      t.integer :podcast_id

      t.timestamps
    end
  end
end
