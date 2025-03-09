Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # API versioning
  namespace :api do
    namespace :v1 do
      # Add your API endpoints here
      resources :health, only: %i[index]

      resources :auth do
        collection do
          post "login", to: "auth#login"
        end
      end

      resources :users do
        collection do
          get "me", to: "users#me"
        end
      end
    end
  end

  # API documentation
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
end
