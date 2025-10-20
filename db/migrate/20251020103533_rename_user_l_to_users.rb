class RenameUserLToUsers < ActiveRecord::Migration[7.0]
  def change
    rename_table :user_l, :users
  end
end
