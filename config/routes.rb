Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  resources :carts, only: %i[show create] do
    collection do
      post 'add_item', action: :add_item
    end
  end
end
