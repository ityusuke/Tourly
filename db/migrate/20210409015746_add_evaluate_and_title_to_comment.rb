class AddEvaluateAndTitleToComment < ActiveRecord::Migration[5.2]
  def change
    add_column :comments,:title,:string,:null => false
    add_column :comments,:evaluate,:integer,:null => false
    add_column :spots,:x,:string,:null => true
    add_column :spots,:y,:string,:null => true
    add_column :spots,:price,:integer,:null => true
    add_column :spots,:time,:integer,:null => true
    add_column :spots,:evaluate,:integer,:null => false
  end
end
