class UsersController < ApplicationController
  
  before_filter :require_login

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
      format.json { render json: @user }
    end
  end
  
  def new  
    @user = User.new  
  end  
    
  def create  
    @user = User.new(params[:user])  
    if @user.save  
      session[:user_id] = @user.id   
      redirect_to "/", :notice => "Welcome #{@user.name}!"  
    else  
      render "new"  
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
    @attendees = Attendee.where(:user_id => @user.id)
    @attendees.each do |attendee|
      attendee.destroy
    end

    respond_to do |format|
      format.html { redirect_to "/", notice: 'User was deleted' }
      format.json { head :no_content }
    end
  end
  
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to "/", notice: @user.name + ' was updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  def likes
    @user = current_user
    @likes = @user.likes.order('created_at ASC')
    @post_ids = @likes.map{|like| like.post_id}
    @posts = @post_ids.map{|id| Post.where(:id => id).first}
  
    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end
end
