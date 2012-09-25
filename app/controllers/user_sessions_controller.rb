class UserSessionsController < ApplicationController

  def new
    @user_session = UserSession.new
  end

  #NOTE create user session
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      user = User.find_by_email(@user_session.email)
      if user.role == "admin"
        redirect_to admin_admins_path, :notice => "Successfully logged in."
      else
        redirect_to users_path, :notice => "Successfully logged in."
      end
    else
      render :new
    end
  end

  #NOTE Destroy user session
  def destroy
    @user_session = UserSession.find(params[:id])
    @user_session.destroy
    redirect_to root_url, :notice => "Successfully logged out."
  end
end
