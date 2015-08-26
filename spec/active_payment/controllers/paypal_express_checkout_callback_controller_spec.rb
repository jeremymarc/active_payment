require 'helper'

RSpec.describe ActivePayment::PaypalExpressCheckoutCallbackController, type: :controller do
  routes { ActivePayment::Engine.routes }

  before(:each) do
    class MockResponse
      def success?
        true
      end

      def payer_id
        1
      end
    end

    @paypal_response = MockResponse.new
  end

  describe 'success' do
    let!(:transaction) { create(:transaction) }

    it 'should redirect to / if no token is passed' do
      get :success
      expect(response).to redirect_to('/')
    end

    it 'should raise exception if wrong token' do
      expect {
        get :success, token: "invalid_token"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should raise SecurityError if not same ip address' do
      expect {
        get :success, token: transaction.external_id
      }.to raise_error(SecurityError)
    end

    it 'should redirect to / and display error flash message if gateway response is bad' do
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(transaction.ip_address)

      get :success, token: transaction.external_id
      expect(flash[:error]).to be_present
      expect(response).to redirect_to('/')
    end

    it 'should redirect to / and display success flash message if success' do
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(transaction.ip_address)
      expect(transaction.state).to eq 'pending'

      allow_any_instance_of(ActiveMerchant::Billing::PaypalExpressGateway).to receive(:details_for).and_return(@paypal_response)
      allow_any_instance_of(ActiveMerchant::Billing::PaypalExpressGateway).to receive(:purchase).and_return(@paypal_response)

      get :success, token: transaction.external_id
      expect(flash[:success]).to be_present
      expect(response).to redirect_to('/')

      trans = ActivePayment::Transaction.find(transaction.id)
      expect(trans.state).to eq 'completed'
    end
  end

  describe 'cancel' do
    let!(:transaction) { create(:transaction) }

    it 'should redirect to / if no token' do
      get :cancel
      expect(response).to redirect_to('/')
    end

    it 'should raise exception if wrong token' do
      expect {
        get :cancel, token: "invalid_token"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'should raise SecurityError if not same ip address' do
      expect {
        get :cancel, token: transaction.external_id
      }.to raise_error(SecurityError)
    end

    it 'should redirect to / and display error flash message if success' do
      allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(transaction.ip_address)
      expect(transaction.state).to eq 'pending'

      get :cancel, token: transaction.external_id
      expect(flash[:error]).to be_present
      expect(response).to redirect_to('/')

      trans = ActivePayment::Transaction.find(transaction.id)
      expect(trans.state).to eq 'canceled'
    end
  end
end
