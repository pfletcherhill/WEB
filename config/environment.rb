# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
WEB::Application.initialize!

#Mailer method
ActionMailer::Base.smtp_settings = {
:user_name => "thewebproject",
:password => "Calcio1023!",
:domain => "thewebproject.org",
:address => "smtp.sendgrid.net",
:port => 587,
:authentication => :plain,
:enable_starttls_auto => true
}
