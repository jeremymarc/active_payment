ActivePayment::Engine.routes.draw do
  #payments callbacks
  get '/paypal/success', to: 'paypal_express_checkout_callback#success'
  get '/paypal/cancel', to: 'paypal_express_checkout_callback#cancel'

  get '/paypal_adaptive/success', to: 'paypal_adaptive_payment_callback#success'
  get '/paypal_adaptive/cancel', to: 'paypal_adaptive_payment_callback#cancel'
  post '/paypal_adaptive/ipn', to: 'paypal_adaptive_payment_callback#ipn'
end
