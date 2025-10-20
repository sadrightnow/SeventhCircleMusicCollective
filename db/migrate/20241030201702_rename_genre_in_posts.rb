class RenameGenreInPosts < ActiveRecord::Migration[7.2]
  def change
    rename_column :posts, :Genre, :genre
  end
end
