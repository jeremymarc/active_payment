ActivePayment.configure do |config|
  config.paypal_login = ENV['PAYPAL_LOGIN']
  config.paypal_password = ENV['PAYPAL_PASSWORD']
  config.paypal_signature = ENV['PAYPAL_SIGNATURE']
  config.paypal_appid = ENV['PAYPAL_APPID']
  config.default_url_host = 'http://example.com'
end
