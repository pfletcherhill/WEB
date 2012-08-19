class Removethumbnail < ActiveRecord::Migration
  def change
    change_table :posts do |t|
      t.remove :thumbnail_file_name
      t.remove :thumbnail_content_type
      t.remove :thumbnail_file_size
      t.remove :thumbnail_updated_at
    end
  end
end
