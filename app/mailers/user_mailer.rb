class UserMailer < ActionMailer::Base

  def set_password(user)
    @user = user
    mail(:to => user.email, :from => "pansingh@weboniselab.com", :subject => "welcome to webonise", :content_type => "text/html")
  end

  def demo(user)
    mail(:to => user.email, :from => "pansingh@weboniselab.com", :subject => "welcome to webonise", :content_type => "text/html")
  end
end
