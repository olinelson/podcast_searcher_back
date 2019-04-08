class AddAuthorIdToClips < ActiveRecord::Migration[5.2]
  def change
    add_column :clips, :author_id, :integer
  end
end
