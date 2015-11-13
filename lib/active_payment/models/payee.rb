module ActivePayment
  module Models
    class Payee
      attr_accessor :identifier, :primary

      def initialize(identifier:, primary: false)
        @identifier = identifier
        @primary = primary
      end

      def to_paypal_hash
        {
          email: @identifier,
          primary: @primary
        }
      end
    end
  end
end
