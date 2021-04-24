class AddImageAndCommentToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users,:comment,:string,:null => true
    add_column :users,:user_image,:string,:null => true
  end
end
