Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth'

  namespace :api do
    defaults(format: :json) do
      resources :users, only: %i[index show create update destroy]
      resources :accounts, only: %i[index]
    end
  end
end
