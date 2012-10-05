class Admin::AdminsController < ApplicationController
  before_filter :admin_should_be_login
  before_filter :find_current_week, :only => [:assigned_feedback_list]
  before_filter :find_week, :only => [:assigned_feedback_search]

  def index
  end

  def add_user
    @user = User.new
  end

  def create_user
    @user = User.create_user(params[:email], params[:name])
    if @user.valid?
      UserMailer.set_password(@user).deliver
      redirect_to root_path, :notice => "User created successfully!!!!!!!!!!"
    else
      render :add_user
    end
  end

  def assigned_feedback_list
    @feedbacks = UserFeedback.where(:created_at => @begin_date..@end_date).paginate(:page => params[:page], :per_page => 10).order('created_at')
  end

  def assigned_feedback_search
    @feedbacks = UserFeedback.where(:created_at => @begin_date..@end_date).paginate(:page => params[:page], :per_page => 10).order('created_at')
  end

  protected

  def find_current_week
    date = Date.today
    weekday = date.wday
    end_weekday = 6 - weekday
    @begin_date = date.to_datetime.in_time_zone('UTC').beginning_of_day - weekday*24*60*60
    @end_date = date.to_datetime.in_time_zone('UTC').end_of_day + end_weekday*24*60*60
  end

  def find_week
    weekday=params[:date].to_date.wday
    end_weekday = 6 - weekday
    @begin_date = params[:date].to_date.to_datetime.in_time_zone('UTC').beginning_of_day - weekday*24*60*60
    @end_date = params[:date].to_date.to_datetime.in_time_zone('UTC').end_of_day + end_weekday*24*60*60
  end

end
