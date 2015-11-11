require 'helper'

describe ActivePayment::Configuration do
  before(:each) do
    @configuration = ActivePayment::Configuration.new
  end

  it 'set the min amount' do
    @configuration.min_amount = 10
    expect(@configuration.min_amount).to eq(10)
  end

  it 'set the min amount when its not set' do
    expect(@configuration.min_amount).to eq(0)
  end

  it 'set the ip_security to false by default' do
    expect(@configuration.ip_security).to be false
  end

  it 'set the ip_security' do
    @configuration.ip_security = true
    expect(@configuration.ip_security).to be true
  end

  it 'set paypal login' do
    @configuration.paypal_login = 'login@paypal.com'
    expect(@configuration.paypal_login).to eq('login@paypal.com')
  end

  it 'set paypal password' do
    @configuration.paypal_password = 'password'
    expect(@configuration.paypal_password).to eq('password')
  end

  it 'set paypal signature' do
    @configuration.paypal_signature = 'signature'
    expect(@configuration.paypal_signature).to eq('signature')
  end

  it 'set paypal appid' do
    @configuration.paypal_appid = 'appid'
    expect(@configuration.paypal_appid).to eq('appid')
  end

  it 'set the default host' do
    @configuration.default_url_host = 'http://example.com'
    expect(@configuration.default_url_host).to eq('http://example.com')
  end

  it 'set test as false by default' do
    expect(@configuration.test).to be false
  end

  it 'set the test' do
    @configuration.test = true
    expect(@configuration.test).to be true
  end

  it 'set test with a boolean value' do
    @configuration.test = true
    expect(@configuration.test).to be true

    @configuration.test = false
    expect(@configuration.test).to be false
  end

  it 'set test with a string value' do
    @configuration.test = "true"
    expect(@configuration.test).to be true

    @configuration.test = "false"
    expect(@configuration.test).to be false
  end
end
