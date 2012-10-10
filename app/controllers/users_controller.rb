class UsersController < ApplicationController
  before_filter :user_should_be_login, :except => [:new_password, :create_password]
  before_filter :find_user_by_perishable_token, :only => [:new_password, :create_password]
  before_filter :find_current_week, :only => [:given_feedback, :received_feedback]
  before_filter :find_week, :only => [:given_feedback_search, :received_feedback_search]
  before_filter :all_user, :only => [:give_feedback, :received_feedback, :received_feedback_search]
  before_filter :received_user_feedback, :only => [:received_feedback, :received_feedback_search]

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
  end

  def received_feedback_search
    respond_to do |format|
      format.js
      format.html
    end
  end

  protected

  def received_user_feedback
    @feedbacks = logged_in_user.to.where("created_at BETWEEN '#{@begin_date}' AND '#{@end_date}' AND feedback is NOT NULL").paginate(:page => params[:page], :per_page => 10).order('updated_at desc')
  end

  def find_user_by_perishable_token
    @user = User.find_by_perishable_token(params[:id])
  end
end
