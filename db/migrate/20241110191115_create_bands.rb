class CreateBands < ActiveRecord::Migration[7.2]
  def change
    create_table :bands do |t|
      t.string :band_name
      t.string :genre
      t.string :band_bandcamp_link
      t.string :band_instagram_link
      t.string :band_description
      t.string :band_location
      t.string :band_email
      t.string :band_ffo

      t.timestamps
    end
  end
end
