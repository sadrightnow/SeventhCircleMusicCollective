json.extract! band, :id, :band_name, :genre, :band_bandcamp_link, :band_instagram_link, :band_description, :band_location, :band_email, :band_ffo, :profile_picture, :created_at, :updated_at
json.url band_url(band, format: :json)
json.profile_picture url_for(band.profile_picture)
