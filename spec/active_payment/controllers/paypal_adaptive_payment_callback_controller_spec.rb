require 'helper'

RSpec.describe ActivePayment::PaypalAdaptivePaymentCallbackController, type: :controller do
  routes { ActivePayment::Engine.routes }

  describe 'ipn' do
    it 'should throw invalid route if trying to access with GET' do
      # get :ipn
      # p response.inspect
      # response.status.to eq 404
    end

    it 'should raise NoTransactionError if no such transaction' do
      payload = "transaction%5B1%5D.status_for_sender_txn=Pending&transaction%5B1%5D.pending_reason=UNILATERAL&payment_request_date=Wed+Aug+19+11%3A39%3A12+PDT+2015&return_url=http%3A//088da0ca.ngrok.io/payments/paypal/success&fees_payer=EACHRECEIVER&ipn_notification_url=http%3A//088da0ca.ngrok.io/payments/paypal/ipn&transaction%5B1%5D.paymentType=SERVICE&transaction%5B1%5D.id_for_sender_txn=60M289731B8092737&sender_email=support-buyer%40streamup.com&verify_sign=An5ns1Kso7MWUdW4ErQKJJJ4qi4-AB0icniyvWSGgTYS2MPeuSWdNrYN&transaction%5B1%5D.amount=USD+200.00&test_ipn=1&transaction%5B0%5D.id_for_sender_txn=0DV12165W2314574U&transaction%5B0%5D.receiver=marcelle%40turcotte.info&cancel_url=http%3A//088da0ca.ngrok.io/payments/paypal/cancel&transaction%5B1%5D.is_primary_receiver=false&transaction%5B0%5D.is_primary_receiver=false&pay_key=AP-45250901MC1380023&action_type=PAY&transaction%5B0%5D.paymentType=SERVICE&transaction%5B0%5D.status_for_sender_txn=Pending&transaction%5B0%5D.pending_reason=UNILATERAL&transaction%5B1%5D.receiver=jeremy%40remixjobs.com&transaction_type=Adaptive+Payment+PAY&transaction%5B0%5D.amount=USD+101.00&status=COMPLETED&log_default_shipping_address_in_transaction=false&charset=windows-1252&notify_version=UNVERSIONED&reverse_all_parallel_payments_on_error=false"
      expect {
        @request.env['RAW_POST_DATA'] = payload
        post :ipn
      }.to raise_error(ActivePayment::NoTransactionError)
    end

    it 'should set transaction success if paypal return success' do
      key = "AP-45250901MC1380023"
      payload = "transaction%5B1%5D.status_for_sender_txn=Pending&transaction%5B1%5D.pending_reason=UNILATERAL&payment_request_date=Wed+Aug+19+11%3A39%3A12+PDT+2015&return_url=http%3A//088da0ca.ngrok.io/payments/paypal/success&fees_payer=EACHRECEIVER&ipn_notification_url=http%3A//088da0ca.ngrok.io/payments/paypal/ipn&transaction%5B1%5D.paymentType=SERVICE&transaction%5B1%5D.id_for_sender_txn=60M289731B8092737&sender_email=support-buyer%40streamup.com&verify_sign=An5nl1Kso7MWUdW4ErQKJJJ4qi4-AB0icniyvWSGgTYS2MPeuSWdNrYN&transaction%5B1%5D.amount=USD+200.00&test_ipn=1&transaction%5B0%5D.id_for_sender_txn=0DV12165W2314574U&transaction%5B0%5D.receiver=marcelle%40turcotte.info&cancel_url=http%3A//088da0ca.ngrok.io/payments/paypal/cancel&transaction%5B1%5D.is_primary_receiver=false&transaction%5B0%5D.is_primary_receiver=false&pay_key=AP-45250901MC1380023&action_type=PAY&transaction%5B0%5D.paymentType=SERVICE&transaction%5B0%5D.status_for_sender_txn=Pending&transaction%5B0%5D.pending_reason=UNILATERAL&transaction%5B1%5D.receiver=jeremy%40remixjobs.com&transaction_type=Adaptive+Payment+PAY&transaction%5B0%5D.amount=USD+101.00&status=COMPLETED&log_default_shipping_address_in_transaction=false&charset=windows-1252&notify_version=UNVERSIONED&reverse_all_parallel_payments_on_error=false"
      params = {
        external_id: key,
        gateway: 'paypal_adaptive_payment',
        currency: 'usd',
        ip_address: '127.0.0.1',
        amount: 15000,
        payee_id: 1,
        payer_id: 1
      }
      ActivePayment::Services::TransactionCreate.new(params).call

      transaction = ActivePayment::Transaction.find_by(external_id: key)
      expect(transaction.state).to eq 'pending'

      expect {
        @request.env['RAW_POST_DATA'] = payload
        post :ipn
      }.to raise_error(ActivePayment::InvalidGatewayResponseError)

      transaction = ActivePayment::Transaction.find_by(external_id: key)
      expect(transaction.state).to eq 'error'
    end

    it 'should set transaction success if paypal return success' do
      key = "AP-45250901MC1380023"
      payload = "transaction%5B1%5D.status_for_sender_txn=Pending&transaction%5B1%5D.pending_reason=UNILATERAL&payment_request_date=Wed+Aug+19+11%3A39%3A12+PDT+2015&return_url=http%3A//088da0ca.ngrok.io/payments/paypal/success&fees_payer=EACHRECEIVER&ipn_notification_url=http%3A//088da0ca.ngrok.io/payments/paypal/ipn&transaction%5B1%5D.paymentType=SERVICE&transaction%5B1%5D.id_for_sender_txn=60M289731B8092737&sender_email=support-buyer%40streamup.com&verify_sign=An5nl1Kso7MWUdW4ErQKJJJ4qi4-AB0icniyvWSGgTYS2MPeuSWdNrYN&transaction%5B1%5D.amount=USD+200.00&test_ipn=1&transaction%5B0%5D.id_for_sender_txn=0DV12165W2314574U&transaction%5B0%5D.receiver=marcelle%40turcotte.info&cancel_url=http%3A//088da0ca.ngrok.io/payments/paypal/cancel&transaction%5B1%5D.is_primary_receiver=false&transaction%5B0%5D.is_primary_receiver=false&pay_key=AP-45250901MC1380023&action_type=PAY&transaction%5B0%5D.paymentType=SERVICE&transaction%5B0%5D.status_for_sender_txn=Pending&transaction%5B0%5D.pending_reason=UNILATERAL&transaction%5B1%5D.receiver=jeremy%40remixjobs.com&transaction_type=Adaptive+Payment+PAY&transaction%5B0%5D.amount=USD+101.00&status=COMPLETED&log_default_shipping_address_in_transaction=false&charset=windows-1252&notify_version=UNVERSIONED&reverse_all_parallel_payments_on_error=false"
      params = {
        external_id: key,
        gateway: 'paypal_adaptive_payment',
        currency: 'usd',
        ip_address: '127.0.0.1',
        amount: 15000,
        payee_id: 1,
        payer_id: 1
      }
      ActivePayment::Services::TransactionCreate.new(params).call

      transaction = ActivePayment::Transaction.find_by(external_id: key)
      expect(transaction.state).to eq 'pending'

      allow_any_instance_of(ActiveMerchant::Billing::Integrations::PaypalAdaptivePayment::Notification).to receive(:acknowledge).and_return(true)
      allow_any_instance_of(ActiveMerchant::Billing::Integrations::PaypalAdaptivePayment::Notification).to receive(:complete?).and_return(true)

      @request.env['RAW_POST_DATA'] = payload
      post :ipn

      transaction = ActivePayment::Transaction.find_by(external_id: key)
      expect(transaction.state).to eq 'completed'
    end
  end
end
