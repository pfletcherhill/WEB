class AddimageIdtoPost < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.integer :image_id
    end
    change_table :images do |t|
      t.remove :post_id
      t.remove :title
    end
  end
end
