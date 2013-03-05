class AdminsController < ApplicationController
  
  before_filter :require_login, :except => ["demo_login"]

  def require_login
    unless logged_in?
      redirect_to '/' # halts request cycle
    end
  end
 
  def logged_in?
    !!current_admin
  end
  
  def index
    @teams = Team.all
    @post = Post.new
    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end
  
  def team
    @team = Team.find(params[:id])
    @users = User.all - @team.users
    @access = AccessControl.new
  end
  
  def demo_login
    user = User.where(:email => "team@thewebproject.org").first
    
    if user  
      session[:user_id] = user.id
      redirect_to "/#team/#{user.teams.first.id}", :notice => "Welcome back #{user.name}"  
    else
      flash[:notice] = 'Invalid Email or Password'
      render "new"
    end
  end
  
end
