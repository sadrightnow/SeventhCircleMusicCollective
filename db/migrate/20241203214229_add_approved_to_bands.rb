class AddApprovedToBands < ActiveRecord::Migration[8.0]
  def change
    add_column :bands, :approved, :boolean
  end
end
