class TeamsController < ApplicationController
  
  before_filter :require_login

  def require_login
    unless logged_in?
      redirect_to '/login' # halts request cycle
    end
  end
 
  def logged_in?
    !!current_user
  end
  
  def posts
    @user = current_user
    
    @posts = Post.where(:team_id => @user.team_id).order('created_at ASC')
    
    @post = Post.new
    
    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end
  
end
