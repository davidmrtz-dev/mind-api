Rails.application.routes.draw do

  namespace :api do
    defaults(format: :json) do
      resources :users, only: %i[create show update destroy]
    end
  end
end
