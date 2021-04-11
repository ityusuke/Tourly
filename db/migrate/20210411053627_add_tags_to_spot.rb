class AddTagsToSpot < ActiveRecord::Migration[5.2]
  def change
    add_column :tours,:tour_tags,:string,:null => true
  end
end
