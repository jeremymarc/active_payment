ActivePayment.configure do |config|
  config.paypal_login = ENV["PAYPAL_LOGIN"]
  config.paypal_password = ENV["PAYPAL_PASSWORD"]
  config.paypal_signature = ENV["PAYPAL_SIGNATURE"]
  config.paypal_appid = ENV["PAYPAL_APPID"]
  config.ip_security = false
  config.min_amount = 0
  config.paypal_express_checkout_callback_controller = 'paypal_express_checkout_callback'
end
