# Active Payment

Active Payment is a Rails engine to handle effortless transactions.
It works with [https://github.com/activemerchant/active_merchant](Active Merchant), and support Paypal Express Checkout
and Paypal Adaptive Payment.

## Installation

### From Git

You can check out the latest source from git:

    git clone git://github.com/jeremymarc/active_payment.git


### From RubyGems

Installation from RubyGems:

    gem install activepayment

Or, if you're using Bundler, just add the following to your Gemfile:

    gem 'active_payment'


## Configuration

Create a active_payment.rb file in config/initializers with your gateway informations

    ActivePayment.configure do |config|
      config.paypal_login = ENV.fetch("PAYPAL_LOGIN")
      config.paypal_password = ENV.fetch("PAYPAL_PASSWORD")
      config.paypal_signature = ENV.fetch("PAYPAL_SIGNATURE")
      config.paypal_appid = ENV.fetch("PAYPAL_APPID")
      config.ip_security = true
      config.min_amount = 1000
    end

And add the callbacks route to your config/routes.rb

     mount ActivePayment::Engine => '/payments'

## Usage

  A sale represent a transaction between a payer, a payee, and a payable object.
  You simply have to add those 3 concerns to your models

  ```ruby
  class User < ActiveRecord::Base
    include ActivePayment::Models::Payer
    include ActivePayment::Models::Payee
  end

  class Phone < ActiveRecord::Base
    include ActivePayment::Models::Payable
  end
  ```


  In your controller, create a sale:
  ```ruby
  payer = User.find(1)
  payee = User.find(2)
  payable = Phone.find(1)

  sale = ActivePayment::Models::Sale.new(payable, payer, payee)
  sales = ActivePayment::Models::Sales.new([sale]) #support multiple sales
  ```


  And call setup_purchase:

  ```ruby
  begin
    payment_gateway = ActivePayment::Gateway.new('paypal_adaptive_payment')
    url = payment_gateway.setup_purchase(sales, request.remote_ip)
  rescue ActivePayment::InvalidAmountError
    render json: 'Invalid amount' and return
  rescue ActivePayment::InvalidGatewayResponseError
    render json: 'Invalid Gateway response' and return
  end

  redirect_to url
  ```

That's it. The engine will take care of the rest: Create a transaction, handle the callback,
and update the transaction once the payment is done.

If you want to override the default behavior or the callback controller, simply create
a app/controllers/active_payment/controller_name.rb:

  ```ruby
  module ActivePayment
    class PaypalExpressCheckoutCallbackController < ActionController::Base
      include ActivePayment::PaypalExpressCheckoutCallback
      protect_from_forgery with: :null_session

      def success
        ... do your custom actions
      end
    end
  end
  ```


## Supported Payment Gateways
* [PayPal Express Checkout](https://www.paypal.com/webapps/mpp/express-checkout)
* [PayPal Adaptive Payment](https://developer.paypal.com/docs/classic/adaptive-payments/integration-guide/APIntro/)
