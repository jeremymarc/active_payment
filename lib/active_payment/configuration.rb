module ActivePayment
  class Configuration
    attr_accessor :paypal_login, :paypal_password, :paypal_signature, :paypal_appid
    attr_accessor :min_amount, :ip_security
    attr_accessor :default_url_host
    attr_accessor :test

    def initialize
      @min_amount = 0
      @ip_security = false
      @test = false
    end

    def test=(value)
      @test = value and return if !!value == value

      @test = (value == 'true' ? true : false)
    end
  end
end
