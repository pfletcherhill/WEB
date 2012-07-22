class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.integer :team_id
      t.boolean :promoted
      
      t.timestamps
    end
    change_table :users do |t|
      t.integer :team_id
    end
  end
end
