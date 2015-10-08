module ActivePayment
  module Models
    module Payee
      extend ActiveSupport::Concern

      included do
        if superclass == ActiveRecord::Base
          has_many :received_transactions, foreign_key: 'payee_id', class_name: 'ActivePayment::Transaction'
        end
      end

      def to_paypal_hash
        {
          email: paypal_identifier,
          primary: false
        }
      end

      def paypal_identifier
        paypal
      end

      module ClassMethods
      end
    end
  end
end
