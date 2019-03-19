class CreateCliptags < ActiveRecord::Migration[5.2]
  def change
    create_table :cliptags do |t|
      t.integer :clip_id
      t.integer :tag_id
      t.timestamps
    end
  end
end
