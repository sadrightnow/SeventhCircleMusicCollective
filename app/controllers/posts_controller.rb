# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :set_genres_and_bands, only: [:new, :edit, :create]
  before_action :authenticate_user!, except: [:index, :show, :past_events]

  def index
    current_time_in_mountain = Time.zone.now.in_time_zone('America/Denver')

    @posts = if user_signed_in?
               Post.where("event_date >= ?", current_time_in_mountain.to_date).order("event_date, time")
             else
               Post.where(visibility: true).where("event_date >= ?", current_time_in_mountain.to_date).order("event_date, time")
             end
  end

  def show
    @genres = Genre.all
    @bands = @post.bands
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        create_google_calendar_event(@post)
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        update_google_calendar_event(@post)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    delete_google_calendar_event(@post)
    @post.destroy!
    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def past_events
    current_date_in_mountain = Time.zone.now.in_time_zone('America/Denver').to_date
    @past_posts = Post.where('event_date < ?', current_date_in_mountain).order(event_date: :desc)

    if params[:search].present?
      @past_posts = @past_posts.where('LOWER(event_name) LIKE ?', "%#{params[:search].downcase}%")
    end

    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date]) rescue nil
      end_date = Date.parse(params[:end_date]) rescue nil
      @past_posts = @past_posts.where(event_date: start_date..end_date) if start_date && end_date
    end

    @past_posts = @past_posts.page(params[:page]).per(100)
  end

  # POST /posts/import_google_calendar
  def import_google_calendar
    return redirect_to new_user_session_path unless user_signed_in?

    service = initialize_google_calendar_service
    calendar_id = '4ranh6c1cr2e3791m1cp83vfmk@group.calendar.google.com'

    time_min = Time.zone.now.beginning_of_day.iso8601
    time_max = 3.months.from_now.end_of_day.iso8601

    events = service.list_events(
      calendar_id,
      single_events: true,
      order_by: 'startTime',
      time_min: time_min,
      time_max: time_max
    )

    imported = 0

    events.items.each do |event|
      start_time = event.start.date || event.start.date_time
      next unless start_time
      event_date = start_time.to_date

      next if Post.exists?(event_date: event_date)

      Post.create!(
        event_name: event.summary || "Untitled Event",
        event_date: event_date,
        time: start_time.to_time.strftime("%H:%M"),
        visibility: false
      )

      imported += 1
    end

    redirect_to posts_path, notice: "#{imported} events imported from Google Calendar."
  rescue Google::Apis::AuthorizationError => e
    redirect_to posts_path, alert: "Authorization error: #{e.message}"
  rescue => e
    redirect_to posts_path, alert: "Something went wrong: #{e.message}"
  end

  # GET /posts/:id/google_calendar_event
  def google_calendar_event
    @post = Post.find(params[:id])
    start_time = Time.zone.parse("#{@post.event_date} #{@post.time}").in_time_zone('America/Denver')
    end_time = start_time + 6.hours

    calendar_url = "https://www.google.com/calendar/render?action=TEMPLATE&text=#{@post.event_name}&dates=#{start_time.strftime('%Y%m%dT%H%M%S')}/#{end_time.strftime('%Y%m%dT%H%M%S')}&details=Event%20from%20Seventh%20Circle%20Music%20Collective&location=Seventh%20Circle%20Music%20Collective"

    redirect_to calendar_url, allow_other_host: true
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def set_genres_and_bands
    @genres = Genre.all
    @bands = Band.all
  end

  def post_params
    params.require(:post).permit(
      :event_name,
      :time,
      :event_date,
      :membership_required,
      :visibility,
      :suggested_donation,
      { genre_ids: [] },
      { band_ids: [] },
      :image,
      :show_poster
    )
  end

  # ----- Google Calendar Integration -----
  def initialize_google_calendar_service
    service = Google::Apis::CalendarV3::CalendarService.new
    service.client_options.application_name = 'Seventh Circle'
    service.authorization = authorize_service_account
    service
  end

  def authorize_service_account
    Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(Rails.root.join('config/service_account.json')),
      scope: Google::Apis::CalendarV3::AUTH_CALENDAR
    )
  end

  def create_google_calendar_event(post)
    service = initialize_google_calendar_service

    start_time = Time.zone.parse("#{post.event_date} #{post.time}").in_time_zone('America/Denver')
    end_time = start_time + 2.hours

    event = Google::Apis::CalendarV3::Event.new(
      summary: post.event_name,
      start: Google::Apis::CalendarV3::EventDateTime.new(date_time: start_time.iso8601, time_zone: 'America/Denver'),
      end: Google::Apis::CalendarV3::EventDateTime.new(date_time: end_time.iso8601, time_zone: 'America/Denver'),
      description: "Event from Seventh Circle Music Collective"
    )

    calendar_id = '4ranh6c1cr2e3791m1cp83vfmka@group.calendar.google.com'
    google_event = service.insert_event(calendar_id, event)

    post.update(google_calendar_event_id: google_event.id)
  rescue StandardError => e
    Rails.logger.error "Google Calendar Error (Create): #{e.message}"
  end

  def update_google_calendar_event(post)
    return unless post.google_calendar_event_id

    service = initialize_google_calendar_service

    start_time = Time.zone.parse("#{post.event_date} #{post.time}").in_time_zone('America/Denver')
    end_time = start_time + 2.hours

    event = service.get_event('4ranh6c1cr2e3791m1cp83vfmka@group.calendar.google.com', post.google_calendar_event_id)
    event.summary = post.event_name
    event.start = Google::Apis::CalendarV3::EventDateTime.new(date_time: start_time.iso8601, time_zone: 'America/Denver')
    event.end = Google::Apis::CalendarV3::EventDateTime.new(date_time: end_time.iso8601, time_zone: 'America/Denver')
    event.description = "Event from Seventh Circle Music Collective"

    service.update_event('4ranh6c1cr2e3791m1cp83vfmka@group.calendar.google.com', event.id, event)
  rescue StandardError => e
    Rails.logger.error "Google Calendar Error (Update): #{e.message}"
  end

  def delete_google_calendar_event(post)
    return unless post.google_calendar_event_id

    service = initialize_google_calendar_service
    service.delete_event('4ranh6c1cr2e3791m1cp83vfmka@group.calendar.google.com', post.google_calendar_event_id)
  rescue StandardError => e
    Rails.logger.error "Google Calendar Error (Delete): #{e.message}"
  end
end

require 'google/apis/calendar_v3'
require 'google/api_client/client_secrets.rb'



