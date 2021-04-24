class RenameSpotImage < ActiveRecord::Migration[5.2]
  def change
    add_column :spots,:spot_images,:string,:null => true
    add_column :spots,:tags,:string,:null => true
  end
end
