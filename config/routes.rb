SmallTweet::Application.routes.draw do
  match "/contact", :to => "pages#contact"
  match "/about", :to => "pages#about"

  root :to => "pages#index"
end
