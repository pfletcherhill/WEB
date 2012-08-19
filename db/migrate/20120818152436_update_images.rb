class UpdateImages < ActiveRecord::Migration
  def change
    change_table :images do |t|
      t.remove :file
      t.string :image
      t.string :title
      t.integer :post_id
    end
  end
end
