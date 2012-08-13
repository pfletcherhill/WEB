class CreateBuckets < ActiveRecord::Migration
  def change
    create_table :buckets do |t|
      t.string :name
      t.text :description
      t.integer :team_id
      t.integer :user_id
      
      t.timestamps
    end
  end
end
