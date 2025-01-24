Rails.application.routes.draw do
  # Devise routes for Admin
  devise_for :admins, controllers: {
    sessions: 'admin/sessions'
  }

  devise_for :customers

  authenticate :customer do
    get '/customers/profile', to: 'customers#profile', as: :customers_profile
    patch '/customers/profile', to: 'customers#update'
  end

  # Admin dashboard
  get "admin", to: "admin#dashboard", as: :admin_dashboard

  # AdminPanel namespace
  namespace :admin_panel, path: "admin" do
    resources :bookings do
      collection do
        get :calendar_data
      end
    end
    resources :properties do
      member do
        get :manage_taxes
        post :create_tax
        delete :destroy_tax
      end
    end
    resources :customers do
      member do
        get :reservations
      end
    end

    resources :search, only: [:new] do
      collection do
        get :results
      end
    end
  end

  # Search functionality
  root "search#index"
  get "search", to: "search#index"

  # Customers lookup
  get '/customers/lookup', to: 'bookings#lookup_customer', as: 'lookup_customer'

  # Properties and nested resources
  resources :properties do
    resources :calendars, only: [:index, :create, :destroy]
    resources :bookings, only: [:index, :new, :create, :show]
  end
end
