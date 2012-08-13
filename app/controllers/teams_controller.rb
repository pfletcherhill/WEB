class TeamsController < ApplicationController
  
  #before_filter :require_login

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
  
  def buckets
    @user = current_user
    @team_id = @user.team_id
    @buckets = Bucket.where(:team_id => @team_id).order('name DESC')
    
    respond_to do |format|
      format.html
      format.json { render json: @buckets }
    end
  end
  
  def new
    @team = Team.new
    @user = current_user
  end
  
  def create
    @team = Team.new(params[:team])
    
    if @team.save
      redirect_to "/admin"
    else
      render action: 'new'
    end
  end
  
  def edit
    @user = current_user
    @team = Team.find(params[:id])
  end
  
  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html { redirect_to "/admin" }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @team = Team.find(params[:id])
    @team.destroy

    respond_to do |format|
      format.html { redirect_to "/admin" }
      format.json { head :no_content }
    end
  end
end
