class Post < ApplicationRecord
  after_create :create_google_calendar_event
  validates :event_name, presence: true
  validates :event_date, presence: true
  has_one_attached :image
  has_one_attached :show_poster
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :bands

  validate :image_size, :show_poster_size

  private

  # Custom validation method to check file size for image
  def image_size
    if image.attached? && image.byte_size > 5.megabytes
      errors.add(:image, "should be less than 5MB")
    end
  end

  # Custom validation method to check file size for show poster
  def show_poster_size
    if show_poster.attached? && show_poster.byte_size > 5.megabytes
      errors.add(:show_poster, "should be less than 5MB")
    end
  end
end



  def create_google_calendar_event
    # Setup the Google Calendar service
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = APPLICATION_NAME
    service.authorization = authorize

    # Prepare the event details
    event = Google::Apis::CalendarV3::Event.new(
      summary: event_name,
      start: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: event_date.to_datetime.iso8601
      ),
      end: Google::Apis::CalendarV3::EventDateTime.new(
        date_time: (event_date.to_datetime + 2.hours).iso8601
      ),
      description: 'Event from your Rails app'
    )

    # Insert the event to the calendar
    calendar_id = 'primary' # 'primary' refers to the main calendar of the authenticated user
    service.insert_event(calendar_id, event)
  rescue StandardError => e
    Rails.logger.error "Google Calendar Error: #{e.message}"
  end

