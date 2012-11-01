class UserMailer < ActionMailer::Base

  def set_password(user)
    @user = user
    mail(:to => user.email, :from => "pansingh@weboniselab.com", :subject => "Getting started with Webonise Feedback Application", :content_type => "text/html")
  end

  def alert_mail(user, names)
    @user = user
    @names = names
    mail(:to => user.email, :from => "pansingh@weboniselab.com", :subject => "feedback to weboniser", :content_type => "text/html")
  end

  def password_reset_mail(user)
    @user = user
    mail(:to => user.email, :from => "pansingh@weboniselab.com", :subject => "You requested a new password for Feedback Application ", :content_type => "text/html")
  end
end
