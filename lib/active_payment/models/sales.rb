module ActivePayment
  module Models
    class Sales
      include Enumerable

      attr_accessor :sales

      def initialize(sales = [])
        @sales = sales
      end

      def amount
        @sales.map(&:amount).inject(0, &:+)
      end

      def amount_in_cents
        @sales.map(&:amount_in_cents).inject(0, &:+)
      end

      def total_shipping
        total_shipping = 0

        @sales.each do |sale|
          total_shipping += sale.shipping if sale.shipping
        end

        total_shipping
      end

      def total_tax
        total_tax = 0

        @sales.each do |sale|
          total_tax += sale.tax if sale.tax
        end

        total_tax
      end

      def paypal_hash
        paypal_hash = []
        @sales.each do |sale|
          paypal_hash << sale.paypal_hash
        end

        paypal_hash
      end

      def each
        @sales.each do |sale|
          yield sale
        end
      end

      def paypal_recipients
        recipients = []
        @sales.each do |sale|
          recipients << sale.paypal_recipient if sale.amount > 0
        end

        recipients
      end


      private

      def items_data
        data = []

        @sales.each do |sale|
          data << { name: sale.description, item_count: 1, item_price: sale.amount, price: sale.amount }
        end

        data
      end
    end
  end
end
