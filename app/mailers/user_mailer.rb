class UserMailer < ActionMailer::Base
  default from: "team@thewebproject.org"
  
  def welcome_email(user)
    @user = user
    @url  = "http://thewebproject.org/start/#{@user.id}"
    mail(:to => user.email, :subject => "You've been invited to WEB")
  end

end