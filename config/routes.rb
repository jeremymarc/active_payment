ActivePayment::Engine.routes.draw do
  default_url_options host: 'localhost:3000'

  get '/paypal/success', to: ActivePayment.configuration.paypal_express_checkout_callback_controller + '#success'
  get '/paypal/cancel', to: ActivePayment.configuration.paypal_express_checkout_callback_controller + '#cancel'

  get '/paypal_adaptive/success', to: ActivePayment.configuration.paypal_adaptive_payment_callback_controller + '#success'
  get '/paypal_adaptive/cancel', to: ActivePayment.configuration.paypal_adaptive_payment_callback_controller + '#cancel'
  post '/paypal_adaptive/ipn', to: ActivePayment.configuration.paypal_adaptive_payment_callback_controller + '#ipn'
end
