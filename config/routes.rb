Rails.application.routes.draw do
  devise_for :vendors
  devise_for :customers
  devise_for :admins
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
  get "/check_thread", to: "home#check_thread"

  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end

  namespace :api do
    namespace :v1 do
      namespace :admin do
        post '/sign_up', to: 'registrations#sign_up'
        post '/login', to: 'sessions#login'
        resources :categories
        get '/requests', to: 'requests#list_of_requests'
        post '/approve_request/:vendor_id', to: 'requests#approve_request'
        post '/reject_request/:vendor_id', to: 'requests#reject_request'
        resources :food_items, only: [:index]
      end

      namespace :customer do
        post '/sign_up', to: 'registrations#sign_up'
        post '/login', to: 'sessions#login'
        resources :categories, only: %i[index show]
        resources :food_items, only: %i[index show]
        resource :carts, only: %i[create destroy update] do
          resources :cart_items
        end
        get '/cart', to: "carts#cart"
        resources :orders do
          post :callback, on: :collection
        end
      end

      namespace :vendor do
        post '/sign_up', to: 'registrations#sign_up'
        post '/login', to: 'sessions#login'
        resources :food_items
        # resource :business_information
        resources :orders do
          put :accept_order
          put :reject_order
          put :preparing_order
          put :ready_for_delivery_order
        end
      end
    end
  end
end
