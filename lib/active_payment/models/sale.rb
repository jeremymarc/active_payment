module ActivePayment
  module Models
    class Sale
      attr_accessor :payable, :payer, :payee

      def initialize(payable:, payer:, payee:)
        @payable = payable
        @payer = payer
        @payee = payee
      end

      def amount
        payable.amount.to_f / 100
      end

      def amount_in_cents
        payable.amount.to_i
      end

      def description
        payable.description
      end

      def shipping
        payable.shipping || 0
      end

      def tax
        payable.tax || 0
      end

      def paypal_recipient
        {
          email: payee.paypal_identifier,
          amount: amount,
          primary: false
        }
      end

      def paypal_hash
        {
          description: payable.description,
          invoice_data: {
            item: [{
              name: payable.description,
              item_count: 1,
              item_price: amount,
              price: amount
            }],
            total_shipping: payable.shipping,
            total_tax: payable.tax
          },
          receiver: {
            email: @payee.paypal_identifier
          }
        }
      end
    end
  end
end
