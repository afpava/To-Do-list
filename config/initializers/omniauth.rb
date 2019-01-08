Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.secrets.GOOGLE_CLIENT_ID, Rails.application.secrets.GOOGLE_SECRET_KEY, {access_type: 'online'}
end
