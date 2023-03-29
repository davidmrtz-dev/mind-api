Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount_devise_token_auth_for 'User', at: 'api/v1/auth'

  namespace :api do
    namespace :v1 do
      defaults(format: :json) do
        resources :users, except: %i[new patch]
        resources :accounts, except: %i[new patch]
        resources :teams, except: %i[new show patch]
        get 'teams/:user_id', to: 'teams#show'
        resources :user_teams, except: %i[new show patch]
      end
    end
  end
end
