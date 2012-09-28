class Admin::UsersController < ApplicationController
  before_filter :admin_should_be_login
  before_filter :find_user, :only => [:to_feedback, :from_feedback]

  def index
    @users =  User.where(:role => "user")
  end
  def assign_user
    @users = User.where(:role => "user")
  end
  def user_list

  end

  def to_feedback
    @feedbacks =  @user.to
  end

  def from_feedback
    @feedbacks =  @user.from
  end

  protected

  def find_user
    @user = User.find(params[:id])
  end
end
