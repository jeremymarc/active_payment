module ActivePayment
  module Models
    class Payable
      include ActivePayment::Models::PaypalPayable

      attr_accessor :id, :class, :description, :amount,
                    :reference_number, :external_id,
                    :shipping, :tax, :number, :quantity,
                    :currency

      def initialize(params = {})
        @tax = 0
        @shipping = 0
        @number = 1
        @quantity = 1
        @currency = 'USD'

        params.each { |key, value| send "#{key}=", value }
      end
    end
  end
end
