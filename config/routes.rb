Rails.application.routes.draw do
  # Devise routes for Admin
  devise_for :admins

  # Admin dashboard
  get "admin", to: "admin#dashboard", as: :admin_dashboard



  # AdminPanel namespace
  namespace :admin_panel, path: "admin" do
    resources :bookings, only: [ :index, :show, :edit, :update, :destroy ]
    resources :properties
    resources :customers do
      member do
        get :reservations
      end
    end
  end


  # Search functionality
  root "search#index"
  get "search", to: "search#index"

  # Properties and nested resources
  resources :properties do
    resources :calendars, only: [ :index, :create, :destroy ]
    resources :bookings, only: [ :index, :new, :create, :show ]
  end
end
