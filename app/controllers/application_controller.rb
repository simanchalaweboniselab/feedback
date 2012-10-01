class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :current_admin
  helper_method :logged_in_user

  def admin_should_be_login
    redirect_to "/login" unless current_admin
  end

  def user_should_be_login
    logger.info "===================================================#{current_user.inspect}"
    redirect_to "/login" unless current_user
  end

  private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  def current_admin
    user.role == "admin" if !user.nil?
  end
  def current_user
    logger.info "=========================================current user=#{user.inspect if !user.nil?}"
    user.role == "user" if !user.nil?
  end
  def logged_in_user
    user
  end
end
