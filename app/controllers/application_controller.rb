class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user,:current_admin,:logged_in_user, :find_current_week, :find_week, :all_user

  def admin_should_be_login
    redirect_to "/login" unless current_admin
  end

  def user_should_be_login
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
    user.role == "user" if !user.nil?
  end
  def logged_in_user
    user
  end

  def find_current_week
    date = Date.today
    weekday = date.wday
    end_weekday = 6 - weekday
    @begin_date = date.to_datetime.in_time_zone('UTC').beginning_of_day - (weekday-1)*24*60*60
    @end_date = date.to_datetime.in_time_zone('UTC').end_of_day + (end_weekday-1)*24*60*60
  end

  def find_week
    weekday=params[:date].to_date.wday
    end_weekday = 6 - weekday
    @begin_date = params[:date].to_date.to_datetime.in_time_zone('UTC').beginning_of_day - (weekday-1)*24*60*60
    @end_date = params[:date].to_date.to_datetime.in_time_zone('UTC').end_of_day + (end_weekday-1)*24*60*60
  end

  def all_user
    @users = User.where(:role => "user")
  end
end
