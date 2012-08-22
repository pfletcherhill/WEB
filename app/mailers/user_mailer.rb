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
    mail(:to => user.email, :subject => "#{user.team.name} has a new post")
  end
end