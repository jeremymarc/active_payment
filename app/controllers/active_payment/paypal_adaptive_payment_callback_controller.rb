module ActivePayment
  class PaypalAdaptivePaymentCallbackController < ActionController::Base
    protect_from_forgery with: :null_session

    include ActivePayment::PaypalAdaptivePaymentCallback
  end
end
