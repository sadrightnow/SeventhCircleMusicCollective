class CreateJoinTablePostsBands < ActiveRecord::Migration[7.2]
  def change
    create_join_table :posts, :bands do |t|
      # t.index [:post_id, :band_id]
      # t.index [:band_id, :post_id]
    end
  end
end
