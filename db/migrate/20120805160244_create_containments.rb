class CreateContainments < ActiveRecord::Migration
  def change
    create_table :containments do |t|
      t.integer :post_id
      t.integer :bucket_id
      
      t.timestamps
    end
  end
end
