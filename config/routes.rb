Rails.application.routes.draw do
  root 'welcome#index'

  # for LINE webhook
  post '/callback' => 'webhook#callback'

  scope 'admin' do
    resources :coupon_settings
  end
end
