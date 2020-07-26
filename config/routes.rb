Rails.application.routes.draw do

  # Added this line because without a homepage,
  # heroku prod won't launch the site.
  namespace :admin do
    get "/", to: "dashboard#index"
    get "/users/:user_id", to: "users#show"
  end

  namespace :merchant do
    get "/", to: "dashboard#index"
  end

  get "/", to: "welcome#index"

  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  patch "/cart", to: "cart#increment_decrement"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"
  delete "/orders/:id", to: "orders#destroy"

  # PROFILE ORDERS
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
  get "/users/edit", to: "users#edit"
  patch "/users/edit", to: "users#update"

  # EDIT PASSWORD
  get "passwords/edit", to: "passwords#edit"
  patch "passwords/edit", to: "passwords#update"

end
