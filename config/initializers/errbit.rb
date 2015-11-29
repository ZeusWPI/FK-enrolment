Airbrake.configure do |config|
  config.api_key = '5b0914cc7a081f32f71f15a5696ca463'
  config.host    = 'errbit.awesomepeople.tv'
  config.port    = 80
  config.secure  = config.port == 443
end
