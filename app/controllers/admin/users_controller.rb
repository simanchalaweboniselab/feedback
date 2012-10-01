class Admin::UsersController < ApplicationController
  before_filter :admin_should_be_login
  before_filter :find_user, :only => [:to_feedback, :from_feedback]

  def index
    @users =  User.where(:role => "user").paginate(:page => params[:page], :per_page => 10)
  end
  def assign_user
    @users = User.where(:role => "user")
  end

  def to_feedback
    @feedbacks =  @user.to.paginate(:page => params[:page], :per_page => 10).order('updated_at desc')
  end

  def from_feedback
    @feedbacks =  @user.from.paginate(:page => params[:page], :per_page => 10).order('created_at desc')
  end

  protected

  def find_user
    @user = User.find(params[:id])
  end
end
