require 'google/apis/calendar_v3'
require 'googleauth'

APPLICATION_NAME = 'Seventh Circle'.freeze
SERVICE_ACCOUNT_KEY_PATH = 'config/service_account.json'.freeze # Replace with the actual path to your service account JSON file
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR
CALENDAR_ID = 'primary' # Replace with a specific calendar ID if needed

def authorize_service_account
  # Load the service account credentials
  Google::Auth::ServiceAccountCredentials.make_creds(
    json_key_io: File.open(SERVICE_ACCOUNT_KEY_PATH),
    scope: SCOPE
  )
end

def create_event(event_name, start_time, end_time)
  # Initialize the Calendar API
  service = Google::Apis::CalendarV3::CalendarService.new
  service.authorization = authorize_service_account
  service.client_options.application_name = APPLICATION_NAME

  # Create an event
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

  # Insert the event into the calendar
  service.insert_event(CALENDAR_ID, event)
end
