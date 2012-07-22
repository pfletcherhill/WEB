WEB::Application.routes.draw do
  
  #Resources
  resources :users
  resources :sessions
  resources :teams
  resources :posts
  resources :likes
  
  #Root
  root :to => 'posts#index'
  
  #Sessions
  match "/login" => "sessions#new"
  match "/logout" => "sessions#destroy"
  
  #Likes
  match "like" => "posts#like", :as => "like_posts"
  match "unlike" => "posts#unlike", :as => "unlike_posts"
  
  #Posts
  match "/posts" => "posts#index"
  match "/promoted" => "posts#promoted"
  match "/posts/:id/likes" => "posts#likes"
  
  #Users
  match "/preferences" => "users#edit"
  match "/user/likes" => "users#likes"
  match "/me" => "users#me"
    
end
