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
      config.default_url_host = "http://example.com"
      config.test = false
    end

And add the callbacks route to your config/routes.rb

     mount ActivePayment::Engine => '/payments'

## Usage

  A sale represent a transaction between a payer, a payee, and a payable object.
  You simply have to add the required methods to your models

  ```ruby
  class User < ActiveRecord::Base
    ...

    def to_payee
      ActivePayment::Models::Payee.new(id: id, paypal_identifier: email)
    end
  end

  class Phone < ActiveRecord::Base
    ...

    def to_payable
      ActivePayment::Models::Payable.new(
      id: id,
      class: self.class,
      amount: amount,
      description: description,
      reference_number: id,
      tax: tax,
      shipping: shipping)
    end
  end
  ```


  In your controller, to create a sale:
  ```ruby
  payer = User.find(1)
  payee = User.find(2)
  payable = Phone.find(1)

  sale = ActivePayment::Models::Sale.new(payable: payable, payer: payer, payee: payee)
  sales = ActivePayment::Models::Sales.new([sale]) #support multiple sales
  ```


  And call setup_purchase:

  ```ruby
  class SalesController < ActionController::Base
    ...

    def new
      begin
        payment_gateway = ActivePayment::Gateway.new('paypal_adaptive_payment')
        url = payment_gateway.setup_purchase(sales, request.remote_ip)
      rescue ActivePayment::InvalidAmountError
        render json: 'Invalid amount' and return
      rescue ActivePayment::InvalidGatewayResponseError
        render json: 'Invalid Gateway response' and return
      end

      redirect_to url
    end
  end
  ```

That's it. The engine will take care of the rest: Create a transaction, handle the callback,
and update the transaction once the payment is done.

If you want to override the default behavior of the callback controller, create a controller class 
keeping the same library path (example: app/controllers/active_payment/paypal_express_checkout.rb):

  ```ruby
  module ActivePayment
    class PaypalExpressCheckoutCallbackController < ActionController::Base
      include Rails.application.routes.url_helpers
      protect_from_forgery with: :null_session

      def success
       ActivePayment::Gateway.verify_purchase_from_request(gateway: 'paypal_express_checkout', request: request, data: purchase_params)
        ... do your custom actions ...

        redirect_to sale_path
      end
    end
  end
  ```


## Supported Payment Gateways
* [PayPal Express Checkout](https://www.paypal.com/webapps/mpp/express-checkout)
* [PayPal Adaptive Payment](https://developer.paypal.com/docs/classic/adaptive-payments/integration-guide/APIntro/)
