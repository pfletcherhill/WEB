class ChangeLikes < ActiveRecord::Migration
  def change
    change_table :likes do |t|
      t.remove :item_id
      t.remove :item_class
      t.integer :post_id
    end
  end
end
