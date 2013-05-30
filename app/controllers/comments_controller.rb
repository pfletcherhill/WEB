class CommentsController < ApplicationController
  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comments.as_json }
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @comment = Comment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comment.as_json }
    end
  end

  # GET /comments/new
  # GET /comments/new.json
  def new
    @comment = Comment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comment.as_json }
    end
  end

  # GET /comments/1/edit
  def edit
    @comment = Comment.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(params[:comment])

    respond_to do |format|
      if @comment.save
        format.html
        format.json { render json: @comment.as_json }
      else
        format.html
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.json
  def update
    @comment = Comment.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        format.html
        format.json { head :no_content }
      else
        format.html
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html
      format.json { head :no_content }
    end
  end
  
  def new_comment_mailer
    @comment = Comment.find(params[:id])
    #Get post author
    post_user = @comment.post.user
    puts "post_user: #{post_user}"
    post_id = @comment.post_id
    related_comments = Comment.where(:post_id => post_id)
    #Get unique related users
    related_users = related_comments.map{|comment| comment.user}.uniq
    puts "related_users: #{related_users}"
    all_users = related_users - [@comment.user]
    users = all_users - [post_user]
    puts "users: #{users}"
    #users.map{ |user| UserMailer.new_related_comment_email(user, @comment).deliver }
    #UserMailer.new_comment_email(post_user, @comment).deliver
    
    respond_to do |format|
      format.html
      format.json { render json: @comment.as_json }
    end
  end
end
