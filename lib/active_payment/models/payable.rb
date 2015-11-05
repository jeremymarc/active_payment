module ActivePayment
  module Models
    class Payable
      attr_accessor :amount, :reference, :description, :shipping, :tax

      def initialize(description:, amount:, reference:, shipping: 0, tax: 0)
        @description = description
        @amount = amount
        @reference = reference
        @shipping = shipping
        @tax = tax
      end

      def to_paypal_hash
        {
          name: description,
          amount: amount.to_i,
          number: 1,
          quantity: 1
        }
      end
    end
  end
end
