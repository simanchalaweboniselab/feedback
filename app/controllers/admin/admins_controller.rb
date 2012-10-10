class Admin::AdminsController < ApplicationController
  before_filter :admin_should_be_login
  before_filter :find_current_week, :only => [:assigned_feedback_list]
  before_filter :find_week, :only => [:assigned_feedback_search]
  before_filter :all_user, :only => [:assigned_feedback_list, :assigned_feedback_search]
  before_filter :feedback, :only => [:assigned_feedback_list, :assigned_feedback_search]

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
  end

  def assigned_feedback_search
    respond_to do |format|
      format.js
      format.html
    end
  end

  protected

  def feedback
    @feedbacks = UserFeedback.where(:created_at => @begin_date..@end_date)
    @recipients = @feedbacks.to_a
    @feedbacks = @feedbacks.to_a.uniq{|feedback| feedback.from_id}
    @feedbacks = @feedbacks.paginate(:page => params[:page], :per_page => 10)
  end

end
