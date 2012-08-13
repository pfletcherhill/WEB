class BucketsController < ApplicationController
  
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
    @bucket = Bucket.find(params[:bucket_id])
    @posts = @bucket.posts
    
    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end
  
  def add_post
  end
  
  def remove_post
    @containment = Containment.where(:bucket_id => params[:bucket_id], :post_id => params[:post_id]).first
    @containment.destroy
    
    respond_to do |format|
      format.html
      format.json { render json: @containment }
    end
  end
end
