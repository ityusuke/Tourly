class AddImageToSpot < ActiveRecord::Migration[5.2]
  def change
    add_column :spots,:spot_images,:string,:null => true
  end
end
