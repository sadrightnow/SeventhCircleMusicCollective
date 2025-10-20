class AddPendingToBands < ActiveRecord::Migration[8.0]
  def change
    add_column :bands, :pending, :boolean, default: true
  end
end