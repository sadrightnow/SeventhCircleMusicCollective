class AddLocalToBands < ActiveRecord::Migration[7.2]
  def change
    add_column :bands, :local, :boolean
  end
end
