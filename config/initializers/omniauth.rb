Rails.application.config.middleware.use OmniAuth::Builder do
  provider :fitbit, 'consumer_key', 'consumer_secret'
end