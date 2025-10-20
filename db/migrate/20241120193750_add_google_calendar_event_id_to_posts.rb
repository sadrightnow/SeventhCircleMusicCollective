class AddGoogleCalendarEventIdToPosts < ActiveRecord::Migration[8.0]
  def change
    add_column :posts, :google_calendar_event_id, :string
  end
end
