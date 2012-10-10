class Admin::UsersController < ApplicationController
  before_filter :admin_should_be_login
  before_filter :find_user, :only => [:to_feedback, :from_feedback, :assigned_feedback, :assigned_feedback_search, :given_feedback_search, :received_feedback_search]
  before_filter :find_week, :only => [:assigned_feedback_search, :given_feedback_search, :received_feedback_search]
  before_filter :find_current_week, :only => [:to_feedback, :from_feedback, :assigned_feedback, :get_from_user_list]
  before_filter :all_user
  before_filter :assigned_user_feedback, :only => [:assigned_feedback, :assigned_feedback_search]
  before_filter :given_user_feedback, :only => [:from_feedback, :given_feedback_search]
  before_filter :received_user_feedback, :only => [:to_feedback, :received_feedback_search]

  def index
    @users = @users.to_a.paginate(:page => params[:page], :per_page => 10)
  end

  def assign_user
  end

  def get_from_user_list
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
  end

  def from_feedback
  end

  def assigned_feedback
  end

  def assigned_feedback_search
    respond_to do |format|
      format.js
      format.html
    end
  end

  def given_feedback_search
    respond_to do |format|
      format.js
      format.html
    end
  end

  def received_feedback_search
    respond_to do |format|
      format.js
      format.html
    end
  end


  protected

  def assigned_user_feedback
    @feedbacks = @user.from.where(:created_at => @begin_date..@end_date)
    @feedbacks = @feedbacks.to_a.uniq{|feedback| feedback.to_id}
    @feedbacks = @feedbacks.paginate(:page => params[:page], :per_page => 10)
  end

  def given_user_feedback
    @feedbacks =  @user.from.where("created_at BETWEEN '#{@begin_date}' AND '#{@end_date}' ")
  end

  def received_user_feedback
    @feedbacks =  @user.to.where("created_at BETWEEN '#{@begin_date}' AND '#{@end_date}' AND feedback is NOT NULL").paginate(:page => params[:page], :per_page => 10).order('updated_at desc')
  end

  def find_user
    @user = User.find(params[:id])
  end
end
