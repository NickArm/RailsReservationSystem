Rails.application.routes.draw do
  namespace :admin_panel do
    get "finances/index"
    get "finances/revenue_report"
    get "finances/pending_payments"
    get "finances/tax_report"
    get "finances/payment_methods"
    get "finances/profitability"
  end

    # Devise routes for Admin
    devise_scope :admin do
      get "login", to: "devise/sessions#new", as: :admin_login
      delete "logout", to: "devise/sessions#destroy", as: :admin_logout
      get "password/new", to: "devise/passwords#new", as: :new_admin_password
      get "password/edit", to: "devise/passwords#edit", as: :edit_admin_password
      patch "password", to: "devise/passwords#update", as: :admin_password
      put "password", to: "devise/passwords#update"
      get "registration/new", to: "devise/registrations#new", as: :new_admin_registration
      get "registration/edit", to: "devise/registrations#edit", as: :edit_admin_registration
      patch "registration", to: "devise/registrations#update"
      put "registration", to: "devise/registrations#update"
      delete "registration", to: "devise/registrations#destroy"
    end

    devise_for :admins,
           path: 'admin',
           skip: [:registrations],
           controllers: {
             sessions: 'admin_panel/devise/sessions'
           },
           path_names: {
             sign_in: 'login',
             sign_out: 'logout'
           }









  # Devise routes for Customers
  devise_for :customers

  # Customer-specific routes
  authenticate :customer do
    get '/customers/profile', to: 'customers#profile', as: :customers_profile
    patch '/customers/profile', to: 'customers#update'
  end

  # Admin dashboard
  get "admin", to: "admin#index", as: :admin_dashboard

  # AdminPanel namespace
  namespace :admin_panel, path: "admin" do
    resources :bookings do
      resources :invoices, only: [:index, :new, :create, :edit, :update]
      collection do
        get :calendar_data
      end

    end

    resources :finances, only: [:index] do
      collection do
        get :revenue_report
        get :pending_payments
        get :tax_report
        get :payment_methods
        get :profitability
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

    resources :invoices

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
    collection do
      post :create_payment_intent
      get :success, path: 'payment_success'
      get :cancel, path: 'payment_cancel'
    end
  end

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
