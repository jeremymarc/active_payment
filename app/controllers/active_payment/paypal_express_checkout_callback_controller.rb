module ActivePayment
  class PaypalExpressCheckoutCallbackController < ActionController::Base
    include ActivePayment::PaypalExpressCheckoutCallback

    protect_from_forgery with: :null_session
  end
end
