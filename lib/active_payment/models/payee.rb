module ActivePayment
  module Models
    class Payee
      include ActivePayment::Models::PaypalPayee

      attr_accessor :id, :paypal_identifier, :primary

      def initialize(id:, paypal_identifier:, primary: false)
        @id = id
        @paypal_identifier = paypal_identifier
        @primary = primary
      end
    end
  end
end
