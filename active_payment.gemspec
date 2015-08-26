# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_payment/version'

Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'active_payment'
  s.version      = ActivePayment::VERSION
  s.summary      = 'Payments transactions'
  s.description  = 'Effortless handle payment transactions with active_merchant.'
  s.license      = "MIT"

  s.author = 'Jeremy Marc'
  s.email = 'jeremy@streamup.com'
  s.homepage = 'http://streamup.com'
  s.rubyforge_project = 'active_payment'

  s.files = Dir["{app,config,db,lib}/**/*"]
  s.require_path = 'lib'

  s.has_rdoc = false

  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1"
  s.add_dependency 'activemerchant', '1.43.3'
  s.add_dependency 'active_paypal_adaptive_payment', '0.3.16'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'factory_girl_rails', '~> 4.5.0'
  s.add_development_dependency 'rspec-rails', '~> 3.3.3'
  s.add_development_dependency 'shoulda-matchers', '~> 2.8.0'
  s.add_development_dependency 'database_cleaner', '~> 1.4.1'
  s.add_development_dependency 'dotenv-rails', '~> 2.0.2'
end
