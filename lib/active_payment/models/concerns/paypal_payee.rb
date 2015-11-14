module ActivePayment
  module Models
    module PaypalPayee
      extend ActiveSupport::Concern

      def to_paypal_hash
        {
          email: @paypal_identifier,
          primary: @primary
        }
      end
    end
  end
end
