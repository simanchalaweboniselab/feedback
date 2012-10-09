class Admin::UsersController < ApplicationController
  before_filter :admin_should_be_login
  before_filter :find_user, :only => [:to_feedback, :from_feedback, :assigned_feedback, :assigned_feedback_search, :given_feedback_search, :received_feedback_search]
  before_filter :find_week, :only => [:assigned_feedback_search, :given_feedback_search, :received_feedback_search]
  before_filter :find_current_week, :only => [:to_feedback, :from_feedback, :assigned_feedback]

  def index
    @users =  User.where(:role => "user").paginate(:page => params[:page], :per_page => 10)
  end
  def assign_user
    @users = User.where(:role => "user")
  end

  def get_from_user_list
    @begin_date =  Date.today.to_datetime.in_time_zone('UTC').beginning_of_day - (Date.today.wday)*24*60*60
    @end_date =  Date.today.to_datetime.in_time_zone('UTC').end_of_day + (6-Date.today.wday)*24*60*60
    @feedback = UserFeedback.where(:created_at => @begin_date..@end_date)
    feedback = @feedback.collect{|f| f.from_id}.zip(params[:from_user] ? params[:from_user] : []).flatten.compact.collect{|s| s.to_i}.uniq
    @users = User.where("id not in(?) and role = 'user' and name LIKE '%#{params[:name_startsWith]}%'", feedback.present? ? feedback : '' )
    render :json => @users
  end

  def get_to_user_list
    @users = User.where("id not in(?) and role = 'user' and name LIKE '%#{params[:name_startsWith]}%'", params[:from_user])
    render :json => @users
  end

  def create_assign_user
    if UserFeedback.assign_feedback(params)
      render :json => {:success => true}
    else
      render :json => {:success => false}
    end
  end

  def to_feedback
    @feedbacks =  @user.to.where("created_at BETWEEN '#{@begin_date}' AND '#{@end_date}' AND feedback is NOT NULL").paginate(:page => params[:page], :per_page => 10).order('updated_at desc')
  end

  def from_feedback
    @feedbacks =  @user.from.where("created_at BETWEEN '#{@begin_date}' AND '#{@end_date}' AND feedback is NOT NULL").paginate(:page => params[:page], :per_page => 10).order('created_at')
  end

  def assigned_feedback
    @feedbacks = @user.from.where(:created_at => @begin_date..@end_date).paginate(:page => params[:page], :per_page => 10).order('created_at')
  end

  def assigned_feedback_search
    @feedbacks = UserFeedback.assigned_feedback(@user, @begin_date, @end_date).paginate(:page => params[:page], :per_page => 10).order('created_at')
  end

  def given_feedback_search
    @feedbacks = UserFeedback.given_feedback(@user, @begin_date, @end_date).paginate(:page => params[:page], :per_page => 10).order('created_at')
  end

  def received_feedback_search
    @feedbacks = UserFeedback.received_feedback(@user, @begin_date, @end_date).paginate(:page => params[:page], :per_page => 10).order('created_at')
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

  def find_user
    @user = User.find(params[:id])
  end
end
