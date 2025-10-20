json.extract! post, :id, :event_name, :time, :event_date, :membership_required, :suggested_donation, :genre, :created_at, :updated_at
json.url post_url(post, format: :json)
