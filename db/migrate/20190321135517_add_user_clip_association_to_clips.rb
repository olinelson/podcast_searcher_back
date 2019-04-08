class AddUserClipAssociationToClips < ActiveRecord::Migration[5.2]
  def change
    add_column :clips, :user_clip_id, :integer
  end
end
