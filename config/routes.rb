Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/auth'

  namespace :api do
    defaults(format: :json) do
      resources :users, except: %i[new patch]
      resources :accounts, except: %i[new patch]
      resources :teams, except: %i[new patch]
    end
  end
end
