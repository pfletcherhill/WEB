class AddUserStuff < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.text :bio
      t.string :year
    end
  end
end
