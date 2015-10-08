module ActivePayment
  module Models
    module Payer
      extend ActiveSupport::Concern

      included do
        if superclass == ActiveRecord::Base
          has_many :sent_transactions, foreign_key: 'payer_id', class_name: 'ActivePayment::Transaction'
        end
      end
    end
  end
end
