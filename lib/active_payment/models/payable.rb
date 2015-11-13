module ActivePayment
  module Models
    class Payable
      attr_accessor :description, :amount, :reference,
                    :reference_number, :external_id, :shipping, :tax,
                    :number, :quantity

      def initialize(params = {})
        @tax = 0
        @shipping = 0
        @number = 1
        @quantity = 1

        params.each { |key, value| send "#{key}=", value }
      end

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
