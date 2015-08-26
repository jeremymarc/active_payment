Rails.application.routes.draw do
  mount ActivePayment::Engine => "/"
end
