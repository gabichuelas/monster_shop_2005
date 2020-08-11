Rails.application.routes.draw do
  get "/", to: "welcome#index"

  namespace :admin do
    get "/", to: "dashboard#index"
    resources :users, only: [:index, :show]
    resources :orders, only: [:update]
    resources :merchants, only: [:show, :index, :update]
    get "merchants/:id/items", to: "items#index"
  end

  namespace :merchant do
    get "/", to: "dashboard#show"
    resources :items
    match "/items/:id/update_status" => 'items#update_status', :via => :patch
    resources :orders, only: [:show]
    resources :item_orders, only: [:update]
  end

  resources :merchants do
    resources :items, only: [:index, :new, :create]
  end

  resources :reviews, only: [:edit, :update, :destroy]
  resources :items, except: [:new, :create] do
    resources :reviews, only: [:new, :create]
  end

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  patch "/cart", to: "cart#increment_decrement"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  resources :orders, only: [:new, :create, :show, :destroy]

  # PROFILE ORDERS
  # refactoring this isn't worthwhile bc of the 'profile' part in the route
  # too much functionality depends on this.
  get "/profile/orders", to: "orders#index"
  get "/profile/orders/:id", to: "orders#show"

  # REGISTER A NEW USER
  get "/register", to: "users#new"
  post "/register", to: "users#create"
  get "/profile", to: "users#show"

  # LOGIN / LOGOUT SESSIONS
  get "/login", to: "sessions#new"
  post '/login', to: 'sessions#create'
  delete "/logout", to: "sessions#destroy"

  # EDIT USER
  resource :users, only: [:edit, :update]
  # EDIT PASSWORD
  resource :passwords, only: [:edit, :update]
end
