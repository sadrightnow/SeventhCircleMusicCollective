require 'google/apis/calendar_v3'
require 'googleauth'

APPLICATION_NAME = 'Seventh Circle'.freeze
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR
CALENDAR_ID = 'primary' # Replace with a specific calendar ID if needed

def service_account_credentials
  json_data = if ENV['GOOGLE_CLIENT_SECRET_JSON']
    # Use Fly.io secret
    ENV['GOOGLE_CLIENT_SECRET_JSON']
  else
    # Local JSON file
    File.read(Rails.root.join('config/google_calendar.json'))
  end

  Google::Auth::ServiceAccountCredentials.make_creds(
    json_key_io: StringIO.new(json_data),
    scope: SCOPE
  )
end

def create_event(event_name, start_time, end_time)
  service = Google::Apis::CalendarV3::CalendarService.new
  service.authorization = service_account_credentials
  service.client_options.application_name = APPLICATION_NAME

  event = Google::Apis::CalendarV3::Event.new(
    summary: event_name,
    start: Google::Apis::CalendarV3::EventDateTime.new(
      date_time: start_time,
      time_zone: 'America/Denver'
    ),
    end: Google::Apis::CalendarV3::EventDateTime.new(
      date_time: end_time,
      time_zone: 'America/Denver'
    )
  )

  service.insert_event(CALENDAR_ID, event)
end

