class UserMailer < ActionMailer::Base
  default from: "team@thewebproject.org"
  
  def welcome_email(user)
    @user = user
    @url  = "http://thewebproject.org/start/#{@user.id}"
    mail(:to => user.email, :subject => "You've been invited to WEB")
  end
  
  def new_post_email(user, post)
    @user = user
    @post = post
    mail(:to => user.email, :subject => "#{post.user.name} posted in #{user.team.name} Workspace")
  end
  
  def new_comment_email(user, comment)
    @user = user
    @comment = comment
    mail(:to => user.email, :subject => "#{comment.user.name} commented on your post")
  end
  
  def new_related_comment_email(user, comment)
    @user = user
    @comment = comment
    mail(:to => user.email, :subject => "#{comment.user.name} responded to your comment")
  end
end