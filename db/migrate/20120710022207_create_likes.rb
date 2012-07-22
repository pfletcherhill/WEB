class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :item_id
      t.integer :item_class
      
      t.timestamps
    end
  end
end
