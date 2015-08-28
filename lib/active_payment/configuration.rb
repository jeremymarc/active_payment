module ActivePayment
  class Configuration
    attr_accessor :paypal_login, :paypal_password, :paypal_signature, :paypal_appid
    attr_accessor :min_amount, :ip_security
    attr_accessor :paypal_adaptive_payment_callback_controller, :paypal_express_checkout_callback_controller

    def initialize
      @min_amount = 0
      @ip_security = false
      @paypal_adaptive_payment_callback_controller = 'paypal_adaptive_payment_callback'
      @paypal_express_checkout_callback_controller = 'paypal_express_checkout_callback'
    end
  end
end
