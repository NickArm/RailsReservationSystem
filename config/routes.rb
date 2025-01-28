Rails.application.routes.draw do
  # Devise routes for Admin
  devise_for :admins, controllers: {
    sessions: 'admin/sessions'
  }

  # Devise routes for Customers
  devise_for :customers

  # Customer-specific routes
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

    resource :settings, only: [:show, :update]

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

  # Payments
  resources :payments, only: [] do
    post :create_payment_intent, on: :collection
  end
  get 'create_payment_intent', to: 'payments#create_payment_intent', as: :create_payment_intent
  get 'payment_success', to: 'payments#success'
  get 'payment_cancel', to: 'payments#cancel'

  # API
  namespace :api do
    namespace :v1 do
      get 'search', to: 'search#index'
      resources :properties, only: [:index]
      resources :bookings, only: [:index]
      resources :customers, only: [:index] do
        collection do
          get 'search_by_email'
        end
      end
    end
  end
end
