module ActivePayment
  class Configuration
    attr_accessor :paypal_login, :paypal_password, :paypal_signature, :paypal_appid
    attr_accessor :min_amount, :ip_security
    attr_accessor :default_url_host

    def initialize
      @min_amount = 0
      @ip_security = false
    end
  end
end
