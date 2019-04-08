class AddProcessingToClips < ActiveRecord::Migration[5.2]
  def change
    add_column :clips, :processing, :boolean
  end
end
