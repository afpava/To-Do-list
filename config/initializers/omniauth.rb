Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, "754802324470-f341bt2mmp7lthm56rftbc3gua304ctr.apps.googleusercontent.com", "-SnTqHApedwSnLoqvVakTtPp", {access_type: 'online'}
end
