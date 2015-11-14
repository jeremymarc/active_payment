module ActivePayment
  module Models
    module PaypalPayable
      extend ActiveSupport::Concern

      def to_paypal_hash
        {
          name: @description,
          amount: @amount.to_i,
          number: @number.to_i,
          quantity: @quantity.to_i
        }
      end
    end
  end
end
