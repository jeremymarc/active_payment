module ActivePayment
  module Models
    module Payable
      extend ActiveSupport::Concern

      def to_paypal_hash
        {
          name: description,
          amount: amount.to_i,
          number: 1,
          quantity: 1,
        }
      end

      def shipping
        shipping
      end

      def tax
        tax
      end

      def reference
        id
      end

      def description
        description
      end
    end
  end
end
