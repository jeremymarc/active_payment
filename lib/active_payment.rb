require 'rubygems'
require 'rails'
require 'activemerchant'
require 'active_paypal_adaptive_payment'

require 'active_payment/engine' if defined?(Rails)
require 'active_payment/gateway'
require 'active_payment/configuration'
require 'active_payment/gateways/paypal_adaptive_payment'
require 'active_payment/gateways/paypal_express_checkout'
require 'active_payment/models/concerns/payee'
require 'active_payment/models/concerns/payer'
require 'active_payment/models/sale'
require 'active_payment/models/sales'
require 'active_payment/models/payable'

module ActivePayment
  attr_accessor :configuration

  class InvalidGatewayResponseError < StandardError; end
  class InvalidAmountError < StandardError; end
  class InvalidItemsError < StandardError; end
  class InvalidGatewayUserError < StandardError; end
  class NoTransactionError < StandardError; end
  class SecurityError < StandardError; end

  class Engine < Rails::Engine; end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
