class AddSchoolUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :school
    end
  end
end
