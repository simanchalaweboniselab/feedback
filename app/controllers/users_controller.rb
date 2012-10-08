class UsersController < ApplicationController
  before_filter :user_should_be_login, :except => [:new_password, :create_password]
  before_filter :find_user_by_perishable_token, :only => [:new_password, :create_password]
  before_filter :find_current_week, :only => [:given_feedback, :received_feedback]
  before_filter :find_week, :only => [:given_feedback_search, :received_feedback_search]

  def index
  end
  def new_password
    if !@user
      redirect_to new_user_session_path
    end
  end
  def create_password
    if @user.update_attributes(params[:user])
      redirect_to users_path, :notice  => "password created successfully!!!!"
    else
      render :new_password
    end
  end

  def update_feedback
    feedback = UserFeedback.find(params[:id])
    feedback.update_attributes(:feedback => params[:feedback])
    redirect_to give_feedback_users_path
  end

  def give_feedback
    feedbacks = logged_in_user.from.where(:feedback => nil)
    @feedbacks = feedbacks.empty? ? "" : feedbacks.select{|feedback|feedback.created_at.strftime("%a-%b-%Y") == Time.now.strftime("%a-%b-%Y")}
  end

  def received_feedback
    @feedbacks = logged_in_user.to.where("created_at BETWEEN '#{@begin_date}' AND '#{@end_date}' AND feedback is NOT NULL").order('updated_at DESC').paginate(:page => params[:page], :per_page => 10).order('updated_at desc')
  end

  def given_feedback
    @feedbacks = logged_in_user.from.where("created_at BETWEEN '#{@begin_date}' AND '#{@end_date}' AND feedback is NOT NULL").paginate(:page => params[:page], :per_page => 10).order('updated_at desc')
  end

  def given_feedback_search
    @feedbacks = logged_in_user.from.where("created_at BETWEEN '#{@begin_date}' AND '#{@end_date}' AND feedback is NOT NULL").paginate(:page => params[:page], :per_page => 10).order('updated_at desc')
  end

  def received_feedback_search
    @feedbacks = logged_in_user.to.where("created_at BETWEEN '#{@begin_date}' AND '#{@end_date}' AND feedback is NOT NULL").order('updated_at DESC').paginate(:page => params[:page], :per_page => 10).order('updated_at desc')
  end

  protected

  def find_user_by_perishable_token
    @user = User.find_by_perishable_token(params[:id])
  end

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
