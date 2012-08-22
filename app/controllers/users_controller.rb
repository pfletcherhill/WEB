class UsersController < ApplicationController
  
  before_filter :require_login, :except => ["onboard", "allow"]

  def require_login
    unless logged_in?
      redirect_to '/login' # halts request cycle
    end
  end
 
  def logged_in?
    !!current_user
  end
  
  def me
    @user = current_user
    respond_to do |format|
      format.json { render json: @user, :except => [ :created_at, :password_hash, :password_salt, :updated_at ] }
    end
  end
  
  def new  
    @user = User.new
    @team = current_user.team
  end  
 
  def create
    @user = User.new(params[:user])
    @team = current_user.team
    
    if @user.save
      UserMailer.welcome_email(@user).deliver
      redirect_to '/admin'
    else
      render :action => "new"
    end
  end
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end  
  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
	
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to "/admin" }
      format.json { head :no_content }
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @team = current_user.team
  end
  
  def update
    @user = User.find(params[:id])
    @team = current_user.team
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html
        format.json { render json: @user, :except => [ :created_at, :password_hash, :password_salt, :updated_at ] }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  def liked_posts
    @user = current_user
    @likes = @user.likes.order('created_at ASC')
    @post_ids = @likes.map{|like| like.post_id}
    @posts = @post_ids.map{|id| Post.where(:id => id).first}
  
    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end
  
  def onboard
    session[:user_id] = nil
    @user = User.where(:id => params[:id]).first
    
    if @user
      if @user.activated?
        redirect_to "/"
      end
    else
      redirect_to "/"
    end
  end
  
  def allow
    @user = User.find(params[:id])
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    @user.save
    
    user = User.authenticate(params[:email], params[:password])  
    
    if user
      session[:user_id] = user.id
      redirect_to "/" 
    else
      redirect_to '/login'
    end
  end
  
  def likes
    @user = User.find(params[:id])
    @likes = @user.likes
    
    respond_to do |format|
      format.html
      format.json { render json: @likes }
    end
  end
  
end
