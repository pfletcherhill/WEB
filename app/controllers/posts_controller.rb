class PostsController < ApplicationController
  
  before_filter :require_login

  def require_login
    unless logged_in?
      redirect_to '/login' # halts request cycle
    end
  end
 
  def logged_in?
    !!current_user
  end
  
  def index
    @user = current_user
    
    @posts = Post.where(:team_id => @user.team_id).order('created_at ASC')
    
    @team = current_user.team
    
    @post = Post.new
    
    respond_to do |format|
      format.html
      format.json { render json: @posts.as_json }
    end    
  end
  
  def create
    @post = Post.new(params[:post])
    respond_to do |format|
      if @post.save
        format.html { redirect_to "/" }
        format.json { render json: @post.as_json }
      else
        format.html { redirect_to "/", notice: 'Better luck next time.' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def new_post_mailer
    @post = Post.find(params[:id])
    @users = @post.team.users
    @users.map{ |user| UserMailer.new_post_email(user, @post).deliver }
    
    respond_to do |format|
      format.html
      format.json { render json: @post.as_json }
    end
  end
  
  def upload
    @post = Post.new(params[:post])
    @team = current_user.team
    respond_to do |format|
      if @post.save
        format.html { redirect_to @post }
        format.json { render json: @post }
      end
    end
  end
  
  def show
    @post = Post.find(params[:id])
    @team = current_user.team
    respond_to do |format|
      format.html
      format.json { render json: @post.as_json }
    end
  end
  
  def likes
    @likes = Like.where(:post_id => params[:id])
    
    respond_to do |format|
      format.html
      format.json { render json: @likes }
    end
  end
  
  def like
    @like = Like.new({ 'user_id' => params[:user_id], 'post_id' => params[:post_id] })
    @like.save
    @post = Post.find(params[:post_id])
    likes_count = @post.likes.count
    
    if likes_count >= 3
      @post.promoted = true
      @post.save
    end
      
    respond_to do |format|
      format.html
      format.json { render json: @like }
    end
  end
  
  def unlike
    @like = Like.where({ 'user_id' => params[:user_id], 'post_id' => params[:post_id] }).first
    @like.destroy
    
    respond_to do |format|
      format.html
      format.json { render json: @like }
    end
  end
  
  def promoted
    @user = current_user
    
    @posts = Post.where(:promoted => true).order('created_at ASC')
    
    @team = @user.team
    
    respond_to do |format|
      format.html
      format.json { render json: @posts.as_json }
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @likes = Like.where(:post_id => @post.id)
    @likes.each do |like|
      like.destroy
    end
    @image = Image.where(:id => @post.image_id).first
    @image.destroy if @image
    @post.destroy

    respond_to do |format|
      format.html { redirect_to "/", notice: 'Post was deleted' }
      format.json { head :no_content }
    end
  end
  
  def new_notice
    @post = Post.new
    @user = current_user
    @team = @user.team
    if current_admin
    else
      redirect_to '/'
    end
  end
  
  def image
    @post = Post.find(params[:id])
    @image = @post.image
    
    respond_to do |format|
      format.html
      format.json { render json: @image }
    end
  end
  
  def comments
    @post = Post.find(params[:id])
    @comments = @post.comments.order('created_at ASC')
    
    respond_to do |format|
      format.html
      format.json { render json: @comments.as_json }
    end
  end
end
