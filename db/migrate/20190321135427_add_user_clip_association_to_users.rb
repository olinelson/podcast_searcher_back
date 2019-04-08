class AddUserClipAssociationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_clip_id, :integer
  end
end
