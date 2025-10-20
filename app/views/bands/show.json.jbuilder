# app/views/bands/_band.json.jbuilder
json.id band.id
json.band_name band.band_name
json.genre band.genre
json.band_description band.band_description
json.band_bandcamp_link band.band_bandcamp_link
json.band_instagram_link band.band_instagram_link
json.band_email band.band_email
json.band_location band.band_location
json.band_ffo band.band_ffo
json.profile_picture_url url_for(band.profile_picture) if band.profile_picture.attached?
