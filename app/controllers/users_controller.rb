class UsersController < ApplicationController
  before_filter :user_should_be_login, :except => [:new_password, :create_password, :forgot_password, :forgot_password_reset, :reset_password, :update_reset_password]
  before_filter :find_user_by_perishable_token, :only => [:new_password, :create_password, :reset_password, :update_reset_password]
  before_filter :find_current_week, :only => [:given_feedback, :received_feedback]
  before_filter :find_week, :only => [:given_feedback_search, :received_feedback_search]
  before_filter :all_user, :only => [:give_feedback, :received_feedback, :received_feedback_search]
  before_filter :received_user_feedback, :only => [:received_feedback, :received_feedback_search]

  #def index
  #end
  def new_password
    if !@user
      redirect_to new_user_session_path
    end
  end
  def change_password
    @user = logged_in_user
  end
  def update_password
    @user = logged_in_user
    if @user.update_attributes(:password => params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      redirect_to home_index_path,:notice => "password reset successfully!!!!"
    else
      render :change_password
    end
  end

  def create_password
    if @user.update_attributes(params[:user])
      redirect_to  home_index_path, :notice  => "password created successfully!!!!"
    else
      render :new_password
    end
  end

  def forgot_password
  end

  def forgot_password_reset
    if @user = User.find_by_email(params[:email])
      UserMailer.password_reset_mail(@user).deliver
      redirect_to home_index_path, :notice => "You will receive an email with instructions about how to reset your password shortly."
    else
      redirect_to forgot_password_users_path, :flash => { :error => "Enter a valid email address" }
    end
  end

  def reset_password
    if @user.nil?
      redirect_to home_index_path
    end
  end
  def update_reset_password
    if @user.update_attributes(params[:user])
      #redirect_to logout_path(@user)
      @user_session = UserSession.find
      @user_session.destroy
      redirect_to home_index_path, :notice  => "password reset successfully"
    else
      render :reset_password
    end
  end

  def update_feedback
    feedback = UserFeedback.find(params[:id])
    if feedback.update_attributes(:feedback => params[:feedback])
      respond_to do |format|
        format.js {render :layout => false}
      end
    else
      redirect_to give_feedback_users_path
    end
  end

  def give_feedback
    feedbacks = logged_in_user.from.where(:feedback => nil)
    @feedbacks = feedbacks.empty? ? "" : feedbacks.select{|feedback|feedback.created_at >= Time.now.beginning_of_day and feedback.created_at <= Time.now.end_of_day}
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
