class AddVisibilityToPosts < ActiveRecord::Migration[7.2]
  def change
    add_column :posts, :visibility, :boolean
  end
end
