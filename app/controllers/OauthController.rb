class OauthController < ApplicationController
  require 'google/apis/calendar_v3'
  require 'googleauth'
  require 'googleauth/stores/file_token_store'

  CLIENT_SECRETS_PATH = Rails.root.join('config', 'client_secret.json')
  CREDENTIALS_PATH = Rails.root.join('config', 'credentials.yaml')
  SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY
  REDIRECT_URI = 'http://localhost:3000/oauth2callback'

  # Step 1: Request authorization
  def authorize
    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)

    if credentials.nil?
      redirect_to authorizer.get_authorization_url(base_url: REDIRECT_URI), allow_other_host: true
    else
      redirect_to root_path, notice: "Already authorized with Google Calendar."
    end
  end

  # Step 2: Handle callback and save credentials
  def callback
    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
    user_id = 'default'
    
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id,
      code: params[:code],
      base_url: REDIRECT_URI
    )

    redirect_to root_path, notice: "Google Calendar authorization successful."
  rescue StandardError => e
    Rails.logger.error "OAuth Callback Error: #{e.message}"
    redirect_to root_path, alert: "Authorization failed. Please try again."
  end
end

