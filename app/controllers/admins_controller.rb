class AdminsController < ApplicationController
  #before_filter :require_login

  def require_login
    unless logged_in?
      redirect_to '/' # halts request cycle
    end
  end
 
  def logged_in?
    !!current_admin
  end
  
  def index
    @user = current_user
    @team = @user.team
    @teams = Team.all
    
    @post = Post.new
    
    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end
end
