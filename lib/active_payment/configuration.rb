module ActivePayment
  class Configuration
    attr_accessor :paypal_login, :paypal_password, :paypal_signature, :paypal_appid
    attr_accessor :min_amount

    def initialize
      @min_amount = 100
    end
  end
end
