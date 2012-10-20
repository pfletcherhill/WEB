WEB::Application.routes.draw do

  resources :comments

  #Resources
  resources :users, :sessions, :teams, :posts, :likes, :buckets, :images, :access_controls
  
  #Root
  root :to => 'posts#index'
  
  #Onboarding
  match "/start/:id" => "users#onboard"
  match "/onboard/:id" => "users#allow", :as => "onboard_users"
  
  #Sessions
  match "/login" => "sessions#new"
  match "/logout" => "sessions#destroy"
  
  #Likes
  match "like" => "posts#like", :as => "like_posts"
  match "unlike" => "posts#unlike", :as => "unlike_posts"
  
  #Posts
  match "/posts" => "posts#promoted"
  match "/promoted" => "posts#promoted"
  match "/posts/:id/likes" => "posts#likes"
  match "/posts/upload" => "posts#upload"
  match "/posts/:id/image" => "posts#image"
  match "/posts/:id/comments" => "posts#comments"
  match "/new_post_mailer/:id" => "posts#new_post_mailer"
  match "/new_comment_mailer/:id" => "comments#new_comment_mailer"
  
  #Teams
  match "/teams/:id/posts" => "teams#posts"
  
  #Users
  match "/preferences" => "users#edit"
  match "/user/likes" => "users#liked_posts"
  match "/me" => "users#me"
  match "/teams/:team_id/add_user" => "users#new"
  match "/users/:id/likes" => "users#likes"
  
  #Buckets
  match "/team/:team_id/buckets" => "teams#buckets" 
  match "/bucket/:bucket_id/posts" => "buckets#posts"
  match "/bucket/:bucket_id/add_post/:post_id" => "buckets#add_post"
  match "/bucket/:bucket_id/remove_post/:post_id" => "buckets#remove_post"
  
  #Admin
  match "/admin" => "admins#index"
  match "/new_notice" => "posts#new_notice"
  match "/new_image" => "images#new"
  match "/admin/teams/:id" => "admins#team"
end
