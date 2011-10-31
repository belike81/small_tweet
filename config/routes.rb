SmallTweet::Application.routes.draw do

  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :posts,    :only => [:create, :destroy]

  match "/contact", :to => "pages#contact"
  match "/about", :to => "pages#about"
  match "/signup", :to => "users#new"
  match "/signin", :to => "sessions#new"
  match "/signout", :to => "sessions#destroy"

  root :to => "pages#index"
end
