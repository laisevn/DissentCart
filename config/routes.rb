require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :carts, only: %i[show create] do
    collection do
      post 'add_item', action: :add_item
    end
  end

  delete '/carts/:id', to: 'carts#delete_item', as: :delete_item
end
