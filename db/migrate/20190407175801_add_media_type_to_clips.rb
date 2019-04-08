class AddMediaTypeToClips < ActiveRecord::Migration[5.2]
  def change
    add_column :clips, :media_type, :string
  end
end
