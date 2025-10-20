class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :event_name
      t.string :time
      t.string :event_date
      t.string :membership_required
      t.string :suggested_donation
      t.string :genre

      t.timestamps
    end
  end
end
