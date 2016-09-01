Rails.application.routes.draw do
  resource :phones, only: [:index] do
    post '/brands', action: 'brands'
    post '/models', action: 'models'
  end

  root 'phones#index'
end
